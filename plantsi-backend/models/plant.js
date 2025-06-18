const mongoose = require('mongoose');

const plantSchema = new mongoose.Schema({
  shopId: String,
  name: String,
  price: Number,
  quantity: Number,
  quality: String,
  type: String,
  imageUrl: String
});

module.exports = mongoose.model('Plant', plantSchema);
