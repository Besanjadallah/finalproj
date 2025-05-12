const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const authMiddleware = require('../middleware/authMiddleware');

// Public routes
router.post('/register', userController.register);
router.post('/login', userController.login);

// Protected routes
router.get('/profile', authMiddleware.isAuthenticated, (req, res) => {
  res.json({ message: "Profile accessed successfully", user: req.user });
});

// Admin-only route
router.patch(
  '/:id/make-admin',
  authMiddleware.isAuthenticated,
  authMiddleware.isAdmin,
  userController.makeAdmin
);

module.exports = router;