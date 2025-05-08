const express = require('express');
const { auth } = require('../middleware/auth');
const { getUserNotifications } = require('../controllers/notificationController');

const notificationRouter = express.Router();

notificationRouter.get('/my', auth, getUserNotifications);

module.exports = notificationRouter;