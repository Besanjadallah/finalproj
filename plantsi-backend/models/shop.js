const mongoose = require('mongoose');
const { Schema, Types } = mongoose;

const shopSchema = new Schema({
  ownerId: { type: Types.ObjectId, ref: 'User' },
  name: String,
  address: String,
  phone: String,
  description: String,
  specialties: [String]
});

// ✅ الحل: استخدم existing model إذا موجود
module.exports = mongoose.models.Shop || mongoose.model('Shop', shopSchema);
