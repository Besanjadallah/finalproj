require('dotenv').config({ path: __dirname + '/.env' }); // هذه السطر ضروري

console.log('Checking environment variables:');
console.log('PORT:', process.env.PORT);
console.log('MONGO_URI:', process.env.MONGO_URI ? 'Exists' : 'Missing');

const express = require('express');
const mongoose = require('mongoose');
const userRoutes = require('./routes/userRoutes');

const app = express();
app.use(express.json());

// تأكد من وجود متغيرات البيئة
if (!process.env.MONGO_URI) {
  console.error('❌ Error: MONGO_URI is not defined in .env file');
  process.exit(1);
}

const port = process.env.PORT || 3000;

mongoose.connect(process.env.MONGO_URI, {
  serverSelectionTimeoutMS: 5000, // وقت انتظار أقل للكشف السريع عن الأخطاء
})
.then(() => console.log('✅ Connected to MongoDB'))
.catch(err => {
  console.error('❌ MongoDB connection error:', err.message);
  process.exit(1); // إيقاف التطبيق إذا فشل الاتصال
});