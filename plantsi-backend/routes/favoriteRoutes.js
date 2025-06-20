const express = require('express');
const router = express.Router();
const {
  addFavorite,
  getFavorites,
  removeFavorite
} = require('../controllers/favoriteController');

const { isAuthenticated } = require('../middlewares/authMiddleware');

// ✅ إضافة للمفضلة
router.post('/add', addFavorite);

// ✅ جلب المفضلات (حسب التوكن)
router.get('/', isAuthenticated, getFavorites);

// ✅ حذف من المفضلة باستخدام POST بدل DELETE
router.post('/remove', isAuthenticated, removeFavorite);

module.exports = router;
