const express = require('express');
const router = express.Router();

const {
  register,
  login,
  createShopOwner,
  makeAdmin
} = require('../controllers/userController');

const {
  isAuthenticated,
  adminOnly,
  isAdmin
} = require('../middleware/authMiddleware');

// ✅ Public routes
router.post('/register', register);
router.post('/login', login);

// ✅ Admin-only route to create shopowner
router.post('/create-shopowner', isAuthenticated, adminOnly, createShopOwner);

// ✅ Protected route to get profile
router.get('/profile', isAuthenticated, (req, res) => {
  res.json({ message: "Profile accessed successfully", user: req.user });
});

// ✅ Admin-only route to promote user
router.patch('/:id/make-admin', isAuthenticated, isAdmin, makeAdmin);

module.exports = router;
