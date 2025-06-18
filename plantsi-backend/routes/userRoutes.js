const express = require('express');
const router = express.Router();

const {
  isAuthenticated,
  adminOnly
} = require('../middlewares/authMiddleware');

const {
  register,
  login,
  createShopOwner,
  makeAdmin,
  getAllUsers,
  getShopOwners,
  getUserById,
  updateUser,
  deleteUser,
  getNormalUsers,
} = require('../controllers/userController');

// 🔐 Auth routes
router.post('/register', register);
router.post('/login', login);

// 👤 Profile route (عرض فقط)
router.get('/profile', isAuthenticated, (req, res) => {
  res.json({ message: "Profile accessed successfully", user: req.user });
});

// 🛠 Admin-only routes
router.post('/create-shopowner', isAuthenticated, adminOnly, createShopOwner);
router.patch('/users/:id/make-admin', isAuthenticated, adminOnly, makeAdmin);
router.get('/users', isAuthenticated, adminOnly, getAllUsers);
router.get('/users/normal', isAuthenticated, adminOnly, getNormalUsers);
router.get('/users/shopowners', isAuthenticated, adminOnly, getShopOwners);
router.get('/users/:id', isAuthenticated, adminOnly, getUserById);
router.put('/users/:id', isAuthenticated, adminOnly, updateUser);
router.delete('/users/:id', isAuthenticated, adminOnly, deleteUser);

module.exports = router;
