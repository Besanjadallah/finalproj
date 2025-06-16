const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const orderSchema = new Schema({
  userId: { type: Types.ObjectId, ref: 'User' },
  shopId: { type: Types.ObjectId, ref: 'Shop' }, // 🔥 ObjectId مش String
  plantId: String,
  plantName: String,
  quantity: Number,
  price: Number,
  date: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Order', orderSchema);
