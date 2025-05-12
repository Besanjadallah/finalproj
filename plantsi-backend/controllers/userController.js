const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// تسجيل مستخدم جديد
exports.register = async (req, res) => {
  try {
    const { name, email, password , role} = req.body;
    
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
      role: 'user' // Role defaults to 'user'
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
exports.login = async (req, res) => {
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


// ... existing code ...

// Make a user an admin
exports.makeAdmin = async (req, res) => {
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