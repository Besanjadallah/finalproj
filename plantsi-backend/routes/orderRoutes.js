const express = require('express');
const router = express.Router();

const Order = require('../models/Order');
const Shop = require('../models/Shop');

<<<<<<< HEAD
const { isAuthenticated, shopOwnerOnly, adminOnly, userOnly, userOrShopOwner } = require('../middlewares/authMiddleware');
=======
const { isAuthenticated, shopOwnerOnly, adminOnly, userOnly, userOrShopOwner } = require('../middleware/authMiddleware');
>>>>>>> tasneem-upload

// ✅ Add Order — user only
router.post('/add', isAuthenticated, userOnly, async (req, res) => {
  try {
    const { shopId, plantId, plantName, quantity, price } = req.body;
    const userId = req.userId;

    const order = new Order({
      shopId,
      userId,
      plantId,
      plantName,
      quantity,
      price,
      date: new Date()
    });

    await order.save();
    res.status(201).json(order);

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ View My Orders — user only
router.get('/my', isAuthenticated, userOnly, async (req, res) => {
  try {
    const orders = await Order.find({ userId: req.userId });
    res.json(orders);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ Get all orders for a shop — shopowner only
router.get('/shop/:shopId', isAuthenticated, shopOwnerOnly, async (req, res) => {
  try {
    const orders = await Order.find({ shopId: req.params.shopId });
    res.json(orders);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ Update order — user or shopowner
router.put('/:orderId', isAuthenticated, userOrShopOwner, async (req, res) => {
  try {
    const order = await Order.findByIdAndUpdate(req.params.orderId, req.body, { new: true });
    res.json(order);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ Delete order — user or shopowner
router.delete('/:orderId', isAuthenticated, userOrShopOwner, async (req, res) => {
  try {
    await Order.findByIdAndDelete(req.params.orderId);
    res.json({ message: 'Order deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// ✅ Sales Ratio — admin only
router.get('/sales-ratio', isAuthenticated, adminOnly, async (req, res) => {
  try {
    const salesData = await Order.aggregate([
      {
        $group: {
          _id: "$shopId",
          totalSales: { $sum: { $multiply: ["$price", "$quantity"] } },
          totalOrders: { $sum: 1 },
          topItem: { $first: "$plantName" }
        }
      },
      {
        $lookup: {
          from: "shops",
          localField: "_id",
          foreignField: "_id",
          as: "shop"
        }
      },
      {
        $unwind: "$shop"
      },
      {
        $project: {
          _id: 0,
          shopId: "$shop._id",
          shopName: "$shop.name",
          totalSales: 1,
          totalOrders: 1,
          topItem: 1
        }
      }
    ]);

    res.json(salesData);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
