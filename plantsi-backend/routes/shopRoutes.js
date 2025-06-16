const express = require('express');
const router = express.Router();
const Shop = require('../models/Shop');

const { isAuthenticated, shopOwnerOnly, adminOnly } = require('../middleware/authMiddleware');

// ✅ Add or Update shop info — shopowner only
router.post('/add', isAuthenticated, shopOwnerOnly, async (req, res) => {
  try {
    const { name, address, phone, description, specialties } = req.body;
    const ownerId = req.userId; // 🔥 ناخده من token — حماية

    let shop = await Shop.findOne({ ownerId });
    if (shop) {
      // update existing shop
      shop.name = name;
      shop.address = address;
      shop.phone = phone;
      shop.description = description;
      shop.specialties = specialties;
      await shop.save();
      return res.json(shop);
    } else {
      // create new shop
      shop = new Shop({ ownerId, name, address, phone, description, specialties });
      await shop.save();
      res.json(shop);
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

router.get('/all', isAuthenticated, adminOnly, async (req, res) => {
  try {
    const shops = await Shop.find();
    res.json(shops);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ Get shop info
router.get('/:ownerId', async (req, res) => {
  try {
    const shop = await Shop.findOne({ ownerId: req.params.ownerId });
    res.json(shop);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});





module.exports = router;
