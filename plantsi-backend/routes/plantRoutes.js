const express = require('express');
const router = express.Router();
const path = require('path');
const multer = require('multer');
const Plant = require('../models/Plant');
const { isAuthenticated, shopOwnerOnly } = require('../middleware/authMiddleware');

// ✅ إعداد multer لتخزين الصور في مجلد uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname))
});

const upload = multer({ storage });

// ✅ إضافة نبتة جديدة
router.post(
  '/add',
  isAuthenticated,
  shopOwnerOnly,
  upload.single('image'),
  async (req, res) => {
    try {
      const { shopId, name, price, quantity, quality, type } = req.body;
      const imageUrl = req.file ? `/uploads/${req.file.filename}` : '';

      const plant = new Plant({
        shopId,
        name,
        price,
        quantity,
        quality,
        type,
        imageUrl
      });

      await plant.save();
      res.json(plant);
    } catch (err) {
      console.error('❌ Failed to add plant:', err);
      res.status(500).json({ error: err.message });
    }
  }
);

// ✅ تحديث نبتة
router.put(
  '/:plantId',
  isAuthenticated,
  shopOwnerOnly,
  upload.single('image'),
  async (req, res) => {
    try {
      const updateData = {
        name: req.body.name,
        price: req.body.price,
        quantity: req.body.quantity,
        quality: req.body.quality,
        type: req.body.type,
      };

      if (req.file) {
        updateData.imageUrl = `/uploads/${req.file.filename}`;
      }

      const plant = await Plant.findByIdAndUpdate(
        req.params.plantId,
        updateData,
        { new: true }
      );

      if (!plant) return res.status(404).json({ message: 'Plant not found' });

      res.json(plant);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  }
);

// ✅ حذف نبتة
router.delete('/:plantId', isAuthenticated, shopOwnerOnly, async (req, res) => {
  try {
    const deleted = await Plant.findByIdAndDelete(req.params.plantId);
    if (!deleted) return res.status(404).json({ message: 'Plant not found' });

    res.json({ message: 'Plant deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ عرض كل النباتات الخاصة بمحطة معيّنة
router.get('/shop/:shopId', async (req, res) => {
  try {
    const plants = await Plant.find({ shopId: req.params.shopId });
    res.json(plants);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
