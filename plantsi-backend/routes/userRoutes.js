const express = require('express');
const router = express.Router();
const { registerUser } = require('../controllers/userController');

// تسجيل مستخدم جديد
router.post('/signup', registerUser);
// تسجيل الدخول
router.post('/login', loginUser);


module.exports = router;
