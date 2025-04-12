const User = require('../models/User');
const bcrypt = require('bcryptjs');

// تسجيل مستخدم جديد
const registerUser = async (req, res) => {
  const { name, email, password, role } = req.body;

  try {
    // التأكد من عدم وجود المستخدم مسبقاً
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: 'Email already exists' });
    }

    // تشفير كلمة المرور
    const hashedPassword = await bcrypt.hash(password, 10);

    // إنشاء مستخدم جديد مع الدور
    const newUser = new User({
      name,
      email,
      password: hashedPassword,
      role: role || 'user', // 👈 "user" هي القيمة الافتراضية إذا ما تم إرسال role
    });

    await newUser.save();

    res.status(201).json({
      message: 'User registered successfully',
      user: {
        id: newUser._id,
        name: newUser.name,
        email: newUser.email,
        role: newUser.role,
      },
    });

  } catch (error) {
    res.status(500).json({ message: 'Something went wrong', error });
  }
};

// تسجيل الدخول
const loginUser = async (req, res) => {
  const { email, password } = req.body;

  try {
    // البحث عن المستخدم
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ message: 'User not found' });
    }

    // التحقق من كلمة المرور
    const isPasswordCorrect = await bcrypt.compare(password, user.password);
    if (!isPasswordCorrect) {
      return res.status(400).json({ message: 'Incorrect password' });
    }

    // إعادة بيانات تسجيل الدخول الناجحة
    res.status(200).json({
      message: 'Login successful',
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    });

  } catch (error) {
    res.status(500).json({ message: 'Login error', error });
  }
};

// تصدير الدوال
module.exports = {
  registerUser,
  loginUser,
};
