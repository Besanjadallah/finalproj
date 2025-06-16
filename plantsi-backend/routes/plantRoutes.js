const express = require('express');
const router = express.Router();
const Plant = require('../models/Plant');


const { isAuthenticated, shopOwnerOnly } = require('../middleware/authMiddleware');

// Add plant
router.post('/add', isAuthenticated, shopOwnerOnly, async (req, res) => {
  try {
    const { shopId, name, price, quantity, quality, type, imageUrl } = req.body;
    const plant = new Plant({ shopId, name, price, quantity, quality, type, imageUrl });
    await plant.save();
    res.json(plant);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Update plant
router.put('/:plantId', async (req, res) => {
  try {
    const plant = await Plant.findByIdAndUpdate(req.params.plantId, req.body, { new: true });
    res.json(plant);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Delete plant
router.delete('/:plantId', async (req, res) => {
  try {
    await Plant.findByIdAndDelete(req.params.plantId);
    res.json({ message: 'Plant deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get all plants for a shop
router.get('/shop/:shopId', async (req, res) => {
  try {
    const plants = await Plant.find({ shopId: req.params.shopId });
    res.json(plants);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
