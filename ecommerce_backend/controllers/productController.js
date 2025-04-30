const Product = require('../models/Product');

// Add product (seller or admin)
const addProduct = async (req, res) => {
  try {
    const { name, description, price, imageUrl, category, stock } = req.body;
    const seller = req.user.userId; // from JWT
    const product = new Product({ name, description, price, imageUrl, category, stock, seller });
    await product.save();
    res.status(201).json(product);
  } catch (err) {
    res.status(500).json({ msg: 'Server error' });
  }
};

// Update product (admin or seller who owns it)
const updateProduct = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ msg: 'Product not found' });

    if (req.user.role === 'admin' || (req.user.role === 'seller' && product.seller.equals(req.user.userId))) {
      Object.assign(product, req.body);
      await product.save();
      res.json(product);
    } else {
      res.status(403).json({ msg: 'Not authorized' });
    }
  } catch (err) {
    res.status(500).json({ msg: 'Server error' });
  }
};

// Delete product (admin or seller who owns it)
const deleteProduct = async (req, res) => {
  try {
    const product = await Product.findById(req.params.id);
    if (!product) return res.status(404).json({ msg: 'Product not found' });

    if (req.user.role === 'admin' || (req.user.role === 'seller' && product.seller.equals(req.user.userId))) {
      await product.deleteOne();
      res.json({ msg: 'Product deleted' });
    } else {
      res.status(403).json({ msg: 'Not authorized' });
    }
  } catch (err) {
    res.status(500).json({ msg: 'Server error' });
  }
};

// Get all products (public)
// Get all products (public) with pagination
const getAllProducts = async (req, res) => {
  try {
    const page = parseInt(req.query.page) || 1;
    const limit = parseInt(req.query.limit) || 10;
    const skip = (page - 1) * limit;

    const products = await Product.find()
      .populate('seller', 'name email')
      .skip(skip)
      .limit(limit)
      .sort({ createdAt: -1 });

    const total = await Product.countDocuments();

    res.json({
      products,
      currentPage: page,
      totalPages: Math.ceil(total / limit),
      totalProducts: total
    });
  } catch (err) {
    res.status(500).json({ msg: 'Server error' });
  }
};

// Get seller's own products
const getMyProducts = async (req, res) => {
  const products = await Product.find({ seller: req.user.userId });
  res.json(products);
};

module.exports = {
  addProduct,
  getAllProducts,
  getMyProducts,
  updateProduct,
  deleteProduct
}