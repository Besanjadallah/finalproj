const express = require('express');
const router = express.Router();

const {
  register,
  login,
  createShopOwner,
  makeAdmin,
  getAllUsers,
  getShopOwners,
  getUserById,
  updateUser,
  deleteUser
} = require('../controllers/userController');

const {
  isAuthenticated,
  adminOnly,
  isAdmin
} = require('../middleware/authMiddleware');

// ✅ Public routes
router.post('/register', register);
router.post('/login', login);

// ✅ Protected route to get profile
router.get('/profile', isAuthenticated, (req, res) => {
  res.json({ message: "Profile accessed successfully", user: req.user });
});

// ✅ Admin-only route to create shopowner
router.post('/create-shopowner', isAuthenticated, adminOnly, createShopOwner);

// ✅ Admin-only route to promote user to admin
router.patch('/:id/make-admin', isAuthenticated, isAdmin, makeAdmin);

// ✅ Admin-only routes to manage users
router.get('/users', isAuthenticated, adminOnly, getAllUsers);
router.get('/users/shopowners', isAuthenticated, adminOnly, getShopOwners);
router.get('/users/:id', isAuthenticated, adminOnly, getUserById);
router.put('/users/:id', isAuthenticated, adminOnly, updateUser);
router.delete('/users/:id', isAuthenticated, adminOnly, deleteUser);

module.exports = router;