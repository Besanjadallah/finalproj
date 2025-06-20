// routes/orderRoutes.js
const express = require('express');
const router = express.Router();
const Order = require('../models/order');
const { isAuthenticated } = require('../middleware/authMiddleware');

// 🟢 إنشاء طلب جديد
router.post('/', isAuthenticated, async (req, res) => {
  try {
    const { items, totalPrice, paymentMethod, address } = req.body;

    if (!items || !Array.isArray(items) || items.length === 0) {
      return res.status(400).json({ message: 'Items array is required' });
    }

    const newOrder = new Order({
      userId: req.userId,
      items,
      totalPrice,
      paymentMethod,
      address,
    });

    const savedOrder = await newOrder.save();
    res.status(201).json(savedOrder);
  } catch (err) {
    res.status(500).json({ message: 'Error creating order', error: err.message });
  }
});

// 🟡 عرض الطلبات حسب المستخدم
router.get('/:userId', isAuthenticated, async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.params.userId }).sort({ date: -1 });
    res.json(orders);
  } catch (err) {
    res.status(500).json({ message: 'Error fetching orders', error: err.message });
  }
});

module.exports = router;
