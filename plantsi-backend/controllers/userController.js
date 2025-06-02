const User   = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt    = require('jsonwebtoken');

/* ───────────────────────── 1) Register ───────────────────────── */
exports.register = async (req, res) => {
  try {
    const { name, email, password, role } = req.body;

    /* تحقق من وجود الإيميل مسبقًا */
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: 'Email already exists' });
    }

    /* تشفير كلمة المرور */
    const hashedPassword = await bcrypt.hash(password, 12);

    /* إنشاء مستخدم جديد */
    const user = new User({
      name,
      email,
      password: hashedPassword,
      role: role || 'user',
    });
    await user.save();

    /* توليد JWT */
    const token = jwt.sign(
      { id: user._id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    return res.status(201).json({
      message: 'User created successfully',
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    });
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};

/* ───────────────────────── 2) Login ───────────────────────── */
exports.login = async (req, res) => {
  console.log("🚀 Login route hit!");

  try {
    const { email, password } = req.body;

    /* التحقق من وجود المستخدم */
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }

    /* مطابقة كلمة المرور */
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ error: 'Invalid credentials' });
    }

    /* توليد JWT */
    const token = jwt.sign(
      { id: user._id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    return res.json({
      message: 'Login successful',
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        role: user.role,
      },
    });
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};

/* ───────────────────────── 3) Promote to Admin ───────────────────────── */
exports.makeAdmin = async (req, res) => {
  try {
    const userId = req.params.id;

    const user = await User.findByIdAndUpdate(
      userId,
      { role: 'admin' },
      { new: true }
    );
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    return res.json({ message: 'User promoted to admin', user });
  } catch (err) {
    return res.status(500).json({ error: err.message });
  }
};

/* ───────────────────────── 4) Update Profile ─────────────────────────
   - يعتمد على userId الآتي من:
     • middleware (req.userId)  ← في حال استخدمت verifyToken
     • أو من params (req.params.id) كخيار احتياطي
--------------------------------------------------------------------- */
exports.updateUserProfile = async (req, res) => {
  try {
    const userId = req.userId || req.params.id;
    if (!userId) {
      return res.status(400).json({ error: 'User ID not provided' });
    }

    const { name, email, password } = req.body;

    /* تحضير حقول التعديل */
    const updates = {};
    if (name)  updates.name  = name;
    if (email) updates.email = email;
    if (password) {
      updates.password = await bcrypt.hash(password, 12);
    }

    /* تنفيذ التعديل */
    const updatedUser = await User.findByIdAndUpdate(userId, updates, { new: true });
    if (!updatedUser) {
      return res.status(404).json({ error: 'User not found' });
    }

    return res.json({ message: 'User updated successfully', user: updatedUser });
  } catch (err) {
    console.error('Update error:', err);
    return res.status(500).json({ error: err.message });
  }
};

/* ──────────────── تصدير الدوال (للاستخدام في الـ Routes) ─────────────── */
module.exports = {
  register:            exports.register,
  login:               exports.login,
  makeAdmin:           exports.makeAdmin,
  updateUserProfile:   exports.updateUserProfile,
};