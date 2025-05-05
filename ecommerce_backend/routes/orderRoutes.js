const express = require('express');
const { auth, authorizeRoles } = require('../middleware/auth');
const {
  createOrder,
  getUserOrders,
  getAllOrders,
  updateOrderStatus
} = require('../controllers/orderController');

const orderRouter = express.Router();

orderRouter.post('/create', auth, createOrder);
orderRouter.get('/my', auth, getUserOrders);
orderRouter.get('/all', auth, authorizeRoles('admin'), getAllOrders);
orderRouter.put('/:id/update', auth, authorizeRoles('admin'), updateOrderStatus);

module.exports = orderRouter;