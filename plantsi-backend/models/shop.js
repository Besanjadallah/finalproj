const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const shopSchema = new Schema({
  ownerId: { type: Types.ObjectId, ref: 'User' }, // 🔥 صححناها: بدلاً من String → ObjectId
  name: String,
  address: String,
  phone: String,
  description: String,
  specialties: [String]
});

module.exports = mongoose.model('Shop', shopSchema);
