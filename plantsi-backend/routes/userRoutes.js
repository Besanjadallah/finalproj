const express = require('express');
const router = express.Router();
const {
  isAuthenticated,
  adminOnly
} = require('../middleware/authMiddleware'); // ✅ ملاحظة: middleware وليس middlewares

// ✅ استيراد ميدلوير رفع الصور
const upload = require('../middleware/upload');

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
  updateUserProfile,
  changePassword
} = require('../controllers/userController');

// 🔐 Auth routes
router.post('/register', register);
router.post('/login', login);

// 👤 Profile routes
router.get('/profile', isAuthenticated, (req, res) => {
  res.json({ message: "Profile accessed successfully", user: req.user });
});
router.put('/update-profile', isAuthenticated, upload.single('profileImage'), updateUserProfile);
router.put('/change-password', isAuthenticated, changePassword);

// 🛠 Admin-only user management
router.post('/create-shopowner', isAuthenticated, adminOnly, createShopOwner);
router.patch('/users/:id/make-admin', isAuthenticated, adminOnly, makeAdmin);

// ✅ إدارة المستخدمين
router.get('/users', isAuthenticated, adminOnly, getAllUsers);
router.get('/users/normal', isAuthenticated, adminOnly, getNormalUsers);
router.get('/users/shopowners', isAuthenticated, adminOnly, getShopOwners);
router.get('/users/:id', isAuthenticated, adminOnly, getUserById);
router.put('/users/:id', isAuthenticated, adminOnly, updateUser);
router.delete('/users/:id', isAuthenticated, adminOnly, deleteUser);

module.exports = router;
