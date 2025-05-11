const express = require('express');
const { auth } = require('../middleware/auth');
const { 
  getUserNotifications, 
  markNotificationAsRead,
  createSupplierNotification,
  getSupplierNotifications
} = require('../controllers/notificationController');

const notificationRouter = express.Router();

notificationRouter.get('/my', auth, getUserNotifications);
notificationRouter.patch('/:id/read', auth, markNotificationAsRead);
notificationRouter.post('/supplier', auth, createSupplierNotification);
notificationRouter.get('/supplier', auth, getSupplierNotifications);

module.exports = notificationRouter;