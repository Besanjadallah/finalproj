const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },

  email: {
    type: String,
    required: true,
    unique: true
  },

  phone: {
    type: String,
    required: true
  },

  address: {
    type: String,
    required: true
  },

  password: {
    type: String,
    required: true
  },

  profileImage: {
    type: String,
    default: '' // اسم الملف أو رابط الصورة
  },

  role: {
    type: String,
    enum: ['user', 'admin', 'shopowner'],
    default: 'user'
  }
});

module.exports = mongoose.model('User', userSchema);
