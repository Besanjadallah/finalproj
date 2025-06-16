const express = require('express');
const router = express.Router();

const { 
  isAuthenticated, 
  userOnly, 
  adminOnly
  // isAdmin 
} = require('../middleware/authMiddleware');

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
  updateUserProfile,
  getNormalUsers 
} = require('../controllers/userController');

// ✅ Register new user
router.post('/register', register);

// ✅ Login user
router.post('/login', login);

// ✅ Get own profile (any role)
router.get('/profile', isAuthenticated, (req, res) => {
  res.json({ message: "Profile accessed successfully", user: req.user });
});

// ✅ Update own profile (any role)
router.put('/update-profile', isAuthenticated, updateUserProfile);

// ✅ Admin-only route to create shopowner
router.post('/create-shopowner', isAuthenticated, adminOnly, createShopOwner);

// ✅ Admin-only route to promote user to admin
// router.patch('/:id/make-admin', isAuthenticated, isAdmin, makeAdmin);
// ✅ route جديد لعرض users

// ✅ Admin-only routes to manage users
router.get('/users', isAuthenticated, adminOnly, getAllUsers);
router.get('/users/shopowners', isAuthenticated, adminOnly, getShopOwners);
router.get('/users/:id', isAuthenticated, adminOnly, getUserById);
router.put('/users/:id', isAuthenticated, adminOnly, updateUser);
router.get('/users/normal', isAuthenticated, adminOnly, getNormalUsers);
router.get('/normal', isAuthenticated, adminOnly, getNormalUsers);
module.exports = router;
