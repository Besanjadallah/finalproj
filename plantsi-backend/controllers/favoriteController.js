const mongoose = require('mongoose');
const Favorite = require('../models/favoriteModel');

// ✅ إضافة نبتة للمفضلة
exports.addFavorite = async (req, res) => {
  try {
    const { userId, productId } = req.body;
    const plantId = productId;

    console.log('📥 FROM FLUTTER:', req.body);

    if (!userId || !plantId) {
      console.log('❌ Missing userId or plantId');
      return res.status(400).json({ message: 'Missing userId or plantId' });
    }

    const exists = await Favorite.findOne({ userId, plantId });
    if (exists) {
      console.log('⚠️ Already exists:', exists);
      return res.status(409).json({ message: 'Already in favorites' });
    }

    const newFavorite = new Favorite({ userId, plantId });
    await newFavorite.save();

    console.log('✅ Favorite saved to DB:', newFavorite);
    res.status(201).json(newFavorite);
  } catch (err) {
    console.error("🔥 Error in addFavorite:", err);
    res.status(500).json({ message: 'Server error', error: err });
  }
};

// ✅ حذف نبتة من المفضلة
exports.removeFavorite = async (req, res) => {
  try {
    const userId = req.userId;
    const { plantId } = req.body;

    if (!plantId) {
      return res.status(400).json({ message: '❌ Missing plantId' });
    }

    await Favorite.findOneAndDelete({ userId, plantId });

    res.json({ message: 'Removed from favorites ✅' });
  } catch (error) {
    console.error("🔥 Error removing favorite:", error);
    res.status(500).json({ message: 'Error removing favorite', error });
  }
};

// ✅ جلب كل المفضلات للمستخدم
exports.getFavorites = async (req, res) => {
  try {
    const userId = req.userId;

    const favorites = await Favorite.find({ userId }).populate('plantId');

    const result = favorites
      .filter(f => f.plantId)
      .map(fav => ({
        _id: fav._id,
        plantId: fav.plantId._id,
        name: fav.plantId.name,
        image: fav.plantId.imageUrl || fav.plantId.image || '', // حسب الموجود
        price: fav.plantId.price
      }));

    res.json(result);
  } catch (error) {
    console.error("🔥 Error fetching favorites:", error);
    res.status(500).json({ message: 'Error fetching favorites', error });
  }
};
