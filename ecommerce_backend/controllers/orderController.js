const Order = require("../models/Order");
const Product = require("../models/Product");
const Cart = require("../models/Cart");

// create order
const createOrder = async (req, res) => {
  try {
    const { shippingAddress } = req.body;
    const userId = req.user.userId;

    const cart = await Cart.findOne({ user: userId }).populate("items.product");
    if (!cart || cart.items.length === 0) {
      return res.status(400).json({ msg: "Cart is empty" });
    }
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

    // create order
    const order = new Order({
      user: userId,
      items: orderItems,
      total,
      shippingAddress,
    });

    // update product stock
    for (const item of cart.items) {
      const product = await Product.findById(item.product._id);
      if (product.stock < item.quantity) {
        return res.status(400).json({
          msg: `Insufficient stock for product: ${product.name}`,
        });
      }
      product.stock -= item.quantity;
      await product.save();
    }

    await order.save();

    // clear the cart

    cart.items = [];
    await cart.save();

    // return populated order
    const populatedOrder = await Order.findById(order._id)
      .populate("items.product")
      .populate("user", "name email");

    res.status(201).json(populatedOrder);
  } catch (err) {
    res.status(500).json({ msg: "Server error", error: err.message });
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
