const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// تسجيل مستخدم جديد
const register = async (req, res) => {
  try {
    const { name, email, password, role } = req.body;

    // التحقق من وجود المستخدم
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: "Email already exists" });
    }

    // تشفير كلمة المرور
    const hashedPassword = await bcrypt.hash(password, 12);

    // إنشاء مستخدم جديد
    const user = new User({
      name,
      email,
      password: hashedPassword,
      role: role || 'user' // افتراضي user إذا ما تم تحديده
    });

    await user.save();

    // إنشاء token
    const token = jwt.sign(
      { id: user._id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    res.status(201).json({
      message: "User created successfully",
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role
      }
    });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// تسجيل دخول
const login = async (req, res) => {
  try {
    const { email, password } = req.body;

    // البحث عن المستخدم
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ error: "Invalid credentials" });
    }

    // التحقق من كلمة المرور
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: "Invalid credentials" });
    }

    // إنشاء token
    const token = jwt.sign(
      { id: user._id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    res.json({
      message: "Login successful",
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role
      }
    });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// إنشاء Shop Owner من قبل Admin
const createShopOwner = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    // التحقق من وجود المستخدم
    const userExists = await User.findOne({ email });
    if (userExists) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // تشفير كلمة المرور
    const hashedPassword = await bcrypt.hash(password, 10);

    // إنشاء shop owner
    const shopOwner = await User.create({
      name,
      email,
      password: hashedPassword,
      role: 'shopowner'
    });

    res.status(201).json({ message: 'Shop Owner created successfully', shopOwner });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

// ترقية مستخدم ليكون admin
const makeAdmin = async (req, res) => {
  try {
    const userId = req.params.id;
    const user = await User.findByIdAndUpdate(
      userId,
      { role: 'admin' },
      { new: true }
    );
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json({ message: "User promoted to admin", user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// تصدير كل الدوال
module.exports = {
  register,
  login,
  createShopOwner,
  makeAdmin
};
