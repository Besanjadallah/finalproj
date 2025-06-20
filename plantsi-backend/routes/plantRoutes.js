const express = require('express');
const router = express.Router();
const path = require('path');
const multer = require('multer');
const Plant = require('../models/Plant');
const { isAuthenticated, shopOwnerOnly } = require('../middleware/authMiddleware');

// إعداد multer لتخزين الصور في مجلد uploads
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => cb(null, Date.now() + path.extname(file.originalname))
});

const upload = multer({ storage });

// ✅ Add plant with image
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

// ✅ Update plant with optional image
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
      res.json(plant);
    } catch (err) {
      res.status(500).json({ error: err.message });
    }
  }
);

// ✅ Delete plant
router.delete('/:plantId', isAuthenticated, shopOwnerOnly, async (req, res) => {
  try {
    await Plant.findByIdAndDelete(req.params.plantId);
    res.json({ message: 'Plant deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ Get all plants for a shop
router.get('/shop/:shopId', async (req, res) => {
  try {
    const plants = await Plant.find({ shopId: req.params.shopId });
    res.json(plants);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
