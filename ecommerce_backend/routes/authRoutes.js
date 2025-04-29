const express = require('express');
const router = express.Router();
const {
    register,
    login,
    getProfile,
    promoteUser
} = require('../controllers/authController');
const { auth, authorizeRoles } = require('../middleware/auth');

router.post('/register', register);
router.post('/login', login);
router.get('/me', auth, getProfile);
router.post('/promote', auth, authorizeRoles('admin'), promoteUser);

module.exports = router;