const Notification = require('../models/Notification');

const getUserNotifications = async (req, res) => {
  try {
    const notifications = await Notification.find({ recipient: req.user.userId })
      .sort({ createdAt: -1 })
      .populate({
        path: 'orderId',
        select: 'items total shippingAddress',
        populate: {
          path: 'items.product',
          select: 'name price images'
        }
      });

    res.json(notifications);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const markNotificationAsRead = async (req, res) => {
  try {
    const notification = await Notification.findOneAndUpdate(
      { _id: req.params.id, recipient: req.user.userId },
      { isRead: true },
      { new: true }
    );

    if (!notification) {
      return res.status(404).json({ error: 'Notification not found' });
    }

    res.json(notification);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// New function to create supplier notifications
const createSupplierNotification = async (req, res) => {
  try {
    const { supplierId, title, message, orderId } = req.body;
    
    // Validate input
    if (!supplierId || !title || !message) {
      return res.status(400).json({ error: 'Missing required fields' });
    }
    
    const notification = new Notification({
      recipient: supplierId,
      title,
      message,
      type: 'supplier',
      orderId: orderId || null
    });
    
    await notification.save();
    res.status(201).json(notification);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// Get supplier notifications (for suppliers only)
const getSupplierNotifications = async (req, res) => {
  try {
    // Check if user is a supplier/seller
    if (req.user.role !== 'seller' && req.user.role !== 'admin') {
      return res.status(403).json({ error: 'Not authorized' });
    }
    
    const notifications = await Notification.find({ 
      recipient: req.user.userId,
      type: 'supplier' 
    })
    .sort({ createdAt: -1 })
    .populate({
      path: 'orderId',
      select: 'items total status createdAt',
      populate: {
        path: 'items.product',
        select: 'name price imageUrl'
      }
    });
    
    res.json(notifications);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

module.exports = {
  getUserNotifications,
  markNotificationAsRead,
  createSupplierNotification,
  getSupplierNotifications
};