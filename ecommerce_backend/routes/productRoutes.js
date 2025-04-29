const express = require('express');
const { auth, authorizeRoles } = require('../middleware/auth');
const {
    addProduct,
    getAllProducts,
    getMyProducts,
    updateProduct,
    deleteProduct
  } = require('../controllers/productController');
const productRouter = express.Router();

productRouter.get('/', getAllProducts);
productRouter.post('/create', auth, authorizeRoles('seller', 'admin'), addProduct);
productRouter.put('/:id', auth, authorizeRoles('seller', 'admin'), updateProduct);
productRouter.delete('/:id', auth, authorizeRoles('seller', 'admin'), deleteProduct);
productRouter.get('/my', auth, authorizeRoles('seller', 'admin'), getMyProducts);

module.exports = productRouter;