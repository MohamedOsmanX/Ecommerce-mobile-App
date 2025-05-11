const Order = require("../models/Order");
const Product = require("../models/Product");
const Cart = require("../models/Cart");
const mongoose = require('mongoose')
const Notification = require('../models/Notification');

const createOrder = async (req, res) => {
  const session = await mongoose.startSession();
  session.startTransaction();

  try {
    const { shippingAddress } = req.body;
    const userId = req.user.userId;

    // Find cart
    const cart = await Cart.findOne({ user: userId })
      .populate('items.product')
      .session(session);

    if (!cart || cart.items.length === 0) {
      await session.abortTransaction();
      return res.status(400).json({ msg: 'Cart is empty' });
    }

    // Calculate total and create order items
    let total = 0;
    const orderItems = cart.items.map((item) => {
      const itemTotal = item.product.price * item.quantity;
      total += itemTotal;
      return {
        product: item.product._id,
        quantity: item.quantity,
        price: item.product.price,
      };
    });

    // Create order
    const order = new Order({
      user: userId,
      items: orderItems,
      total,
      shippingAddress,
      status: 'pending',
    });

    // Save order
    await order.save({ session });

    // Clear cart
    await Cart.findOneAndUpdate(
      { _id: cart._id },
      { $set: { items: [] } },
      { session, new: true }
    );

    // Create a notification for the user
    const notification = new Notification({
      recipient: userId,
      title: 'Order Confirmed',
      message: `Your order #${order._id} has been confirmed.`,
      type: 'order',
      orderId: order._id
    });
    await notification.save({ session });

    // Create notifications for suppliers (sellers)
    const supplierMap = new Map(); // To track unique suppliers

    for (const item of cart.items) {
      // Get the product with its seller (supplier)
      const product = await Product.findById(item.product._id)
        .populate('seller', 'name email')
        .session(session);

      if (product && product.seller) {
        const supplierId = product.seller._id.toString();
        
        // If we haven't created a notification for this supplier yet
        if (!supplierMap.has(supplierId)) {
          supplierMap.set(supplierId, {
            items: [],
            total: 0
          });
        }
        
        // Add this item to the supplier's list
        supplierMap.get(supplierId).items.push({
          name: product.name,
          quantity: item.quantity,
          price: product.price
        });
        
        // Update total for this supplier
        supplierMap.get(supplierId).total += item.quantity * product.price;
      }
    }

    // Create individual notifications for each supplier
    const supplierNotifications = [];
    for (const [supplierId, data] of supplierMap.entries()) {
      const itemsList = data.items.map(i => `${i.quantity}x ${i.name}`).join(', ');
      
      const notification = new Notification({
        recipient: supplierId,
        title: 'New Order Received',
        message: `A customer has ordered: ${itemsList}. Order total: $${data.total.toFixed(2)}`,
        type: 'supplier',
        orderId: order._id
      });
      
      supplierNotifications.push(notification);
    }

    // Save all supplier notifications
    if (supplierNotifications.length > 0) {
      await Notification.insertMany(supplierNotifications, { session });
    }

    // Commit transaction
    await session.commitTransaction();

    // Return populated order
    const populatedOrder = await Order.findById(order._id)
      .populate('items.product')
      .populate('user', 'name email');

    res.status(201).json(populatedOrder);
  } catch (error) {
    await session.abortTransaction();
    console.error('Order creation error:', error);
    res.status(500).json({ msg: 'Server error', error: error.message });
  } finally {
    session.endSession();
  }
};

// Get user's orders
const getUserOrders = async (req, res) => {
    try {
      const orders = await Order.find({ user: req.user.userId })
        .populate('items.product')
        .sort({ createdAt: -1 });
      res.json(orders);
    } catch (err) {
      res.status(500).json({ msg: 'Server error', error: err.message });
    }
  };
  
  // Get all orders (admin only)
  const getAllOrders = async (req, res) => {
    try {
      const orders = await Order.find()
        .populate('items.product')
        .populate('user', 'name email')
        .sort({ createdAt: -1 });
      res.json(orders);
    } catch (err) {
      res.status(500).json({ msg: 'Server error', error: err.message });
    }
  };
  
  // Update order status (admin only)
  const updateOrderStatus = async (req, res) => {
    try {
      const { status } = req.body;
      const order = await Order.findById(req.params.id);
      
      if (!order) {
        return res.status(404).json({ msg: 'Order not found' });
      }
  
      order.status = status;
      await order.save();
  
      res.json(order);
    } catch (err) {
      res.status(500).json({ msg: 'Server error', error: err.message });
    }
  };
  
  module.exports = {
    createOrder,
    getUserOrders,
    getAllOrders,
    updateOrderStatus
  };
