const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  email: { 
    type: String, 
    required: true, 
    unique: true 
  },
  password: { 
    type: String, 
    required: true 
  },
  name: { 
    type: String 
  },
  role: {
    type: String,
    enum: ['user', 'admin'], // 👈 فقط نوعين مسموحين
    default: 'user' // 👈 المستخدم العادي هو الافتراضي
  }
});

module.exports = mongoose.model('User', userSchema);
