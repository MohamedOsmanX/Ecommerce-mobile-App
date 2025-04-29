const Cart = require('../models/Cart');

const getCart = async (req, res) => {
  const cart = await Cart.findOne({ user: req.user.userId }).populate('items.product');
  res.json(cart || { user: req.user.userId, items: [] });
};

const addToCart = async (req, res) => {
  const { productId, quantity } = req.body;
  let cart = await Cart.findOne({ user: req.user.userId });
  if (!cart) cart = new Cart({ user: req.user.userId, items: [] });

  const itemIndex = cart.items.findIndex(item => item.product.toString() === productId);
  if (itemIndex > -1) {
    cart.items[itemIndex].quantity += quantity || 1;
  } else {
    cart.items.push({ product: productId, quantity: quantity || 1 });
  }
  await cart.save();
  res.json(cart);
};

const removeFromCart = async (req, res) => {
  const { productId } = req.body;
  const cart = await Cart.findOne({ user: req.user.userId });
  if (cart) {
    cart.items = cart.items.filter(item => item.product.toString() !== productId);
    await cart.save();
  }
  res.json(cart);
};

const clearCart = async (req, res) => {
  const cart = await Cart.findOne({ user: req.user.userId });
  if (cart) {
    cart.items = [];
    await cart.save();
  }
  res.json(cart);
};

module.exports = {
    getCart,
    addToCart,
    removeFromCart,
    clearCart
}