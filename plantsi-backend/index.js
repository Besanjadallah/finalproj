require('dotenv').config({ path: __dirname + '/.env' }); // تحميل متغيرات البيئة

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');

const app = express();

// ✅ تسجيل الراوترات
const userRoutes = require('./routes/userRoutes');
const shopRoutes = require('./routes/shopRoutes');
const plantRoutes = require('./routes/plantRoutes');
const orderRoutes = require('./routes/orderRoutes');
const favoriteRoutes = require('./routes/favoriteRoutes');
const plantAnalysisRoutes = require('./routes/plantAnalysisRoutes');

console.log('🧩 جميع الراوترات تم تحميلها');

app.use(express.json());
app.use(cors());
app.use('/uploads', express.static('uploads'));
app.use('/api/plant', plantAnalysisRoutes);


/* ──────────── فحص متغيرات البيئة ──────────── */
console.log('🛠️ Checking environment variables:');
if (!process.env.MONGO_URI) {
  console.error('❌ MONGO_URI is missing from .env file');
  process.exit(1);
} else {
  console.log('✅ MONGO_URI exists');
}
console.log('PORT:', process.env.PORT || 'default 8080');

/* ──────────── ربط الراوتات ──────────── */
app.use('/api/users', userRoutes);          // تسجيل الدخول والتسجيل
app.use('/api/shops', shopRoutes);          // راوتر المحلات
app.use('/api/plants', plantRoutes);        // راوتر النباتات
app.use('/api/orders', orderRoutes);        // ✅ راوتر الطلبات (جديد)
app.use('/api/favorites', favoriteRoutes);  // راوتر المفضلة

/* ──────────── مسار اختبار ──────────── */
app.get('/', (req, res) => {
  console.log("🌱 Root route hit!");
  res.json({ message: "Welcome to Plantsi backend 🌿" });
});

/* ──────────── الاتصال بقاعدة البيانات ──────────── */
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
  serverSelectionTimeoutMS: 5000
})
.then(() => console.log('✅ Connected to MongoDB'))
.catch(err => {
  console.error('❌ MongoDB connection error:', err.message);
  process.exit(1);
});

/* ──────────── تشغيل السيرفر ──────────── */
const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log(`🚀 Server is running on port ${port}`);
});
