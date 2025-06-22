const express = require('express');
const router = express.Router();
const Shop = require('../models/Shop');

const { isAuthenticated, shopOwnerOnly, adminOnly } = require('../middlewares/authMiddleware');

// ✅ Add or Update shop info — shopowner only
router.post('/add', isAuthenticated, shopOwnerOnly, async (req, res) => {
  try {
    const { name, address, phone, description, specialties } = req.body;
    const ownerId = req.userId;

    let shop = await Shop.findOne({ ownerId });
    if (shop) {
      shop.name = name;
      shop.address = address;
      shop.phone = phone;
      shop.description = description;
      shop.specialties = specialties;
      await shop.save();
      return res.json(shop);
    } else {
      shop = new Shop({ ownerId, name, address, phone, description, specialties });
      await shop.save();
      res.json(shop);
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ Get all shops with owner name (admin only)
router.get('/all', isAuthenticated, adminOnly, async (req, res) => {
  try {
    const shops = await Shop.find().populate('ownerId', 'name');
    res.json(shops);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ Update shop info by shopId (Flutter will use this)
router.put('/:shopId', isAuthenticated, shopOwnerOnly, async (req, res) => {
  try {
    const { name, address, phone, description, specialties } = req.body;

    const shop = await Shop.findById(req.params.shopId);
    if (!shop) return res.status(404).json({ error: 'Shop not found' });

    // Only owner or admin can update
    if (req.user.role !== 'admin' && shop.ownerId.toString() !== req.userId) {
      return res.status(403).json({ error: 'Unauthorized' });
    }

    // Update fields
    shop.name = name;
    shop.address = address;
    shop.phone = phone;
    shop.description = description;
    shop.specialties = specialties;

    await shop.save();
    res.json({ message: 'Shop updated successfully', shop });
  } catch (err) {
    console.error('❌ Error updating shop:', err.message);
    res.status(500).json({ error: 'Server error while updating shop' });
  }
});

// ✅ Delete shop (Admin or ShopOwner)
router.delete('/:id', isAuthenticated, async (req, res) => {
  try {
    const shop = await Shop.findById(req.params.id);
    if (!shop) return res.status(404).json({ error: 'Shop not found' });

    // Only admin or shop owner can delete
    if (req.user.role !== 'admin' && shop.ownerId.toString() !== req.userId) {
      return res.status(403).json({ error: 'Unauthorized' });
    }

    await shop.deleteOne();
    res.json({ message: 'Shop deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
