const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const path = require('path');

// ✅ تسجيل مستخدم جديد
const register = async (req, res) => {
  try {
    const { name, email, phone, address, password } = req.body;
    const existingUser = await User.findOne({ email });
    if (existingUser) return res.status(400).json({ error: 'Email already exists' });

    const hashedPassword = await bcrypt.hash(password, 12);
    const user = new User({ name, email, phone, address, password: hashedPassword, role: 'user' });
    await user.save();

    const token = jwt.sign({ id: user._id, role: user.role }, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.status(201).json({
      message: 'User registered successfully',
      token,
      user: { id: user._id, name: user.name, email: user.email, phone: user.phone, address: user.address, role: user.role }
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// ✅ تسجيل الدخول
const login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ error: 'Invalid credentials' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ error: 'Invalid credentials' });

    const token = jwt.sign({ id: user._id, role: user.role }, process.env.JWT_SECRET, { expiresIn: '1h' });

    res.json({
      message: 'Login successful',
      token,
      user: { id: user._id, name: user.name, email: user.email, phone: user.phone, address: user.address, role: user.role }
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// ✅ تعديل البروفايل
const updateUserProfile = async (req, res) => {
  try {
    const userId = req.user.id;
    const { name, email, password, phone, address } = req.body;

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: 'User not found' });

    if (name) user.name = name;
    if (email) user.email = email;
    if (phone) user.phone = phone;
    if (address) user.address = address;

    if (password && password.trim() !== '') {
      const salt = await bcrypt.genSalt(10);
      user.password = await bcrypt.hash(password, salt);
    }

    if (req.file) {
      user.profileImage = `/uploads/${req.file.filename}`;
    }

    await user.save();

    res.status(200).json({
      message: 'Profile updated successfully',
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        address: user.address,
        profileImage: user.profileImage,
        role: user.role
      }
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
};

// ✅ تغيير كلمة المرور
const changePassword = async (req, res) => {
  try {
    const userId = req.user.id;
    const { currentPassword, newPassword } = req.body;

    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ error: "User not found" });

    const isMatch = await bcrypt.compare(currentPassword, user.password);
    if (!isMatch) return res.status(400).json({ error: "Current password is incorrect" });

    const salt = await bcrypt.genSalt(10);
    user.password = await bcrypt.hash(newPassword, salt);
    await user.save();

    res.json({ message: "Password changed successfully" });
  } catch (err) {
    res.status(500).json({ error: "Server error" });
  }
};

// ✅ إنشاء ShopOwner
const createShopOwner = async (req, res) => {
  try {
    const { name, email, phone, address, password } = req.body;
    const existingUser = await User.findOne({ email });
    if (existingUser) return res.status(400).json({ error: 'Email already exists' });

    const hashedPassword = await bcrypt.hash(password, 12);
    const shopOwner = new User({ name, email, phone, address, password: hashedPassword, role: 'shopowner' });
    await shopOwner.save();

    res.status(201).json({
      message: 'Shop owner created successfully',
      shopOwner: { id: shopOwner._id, name: shopOwner.name, email: shopOwner.email, phone: shopOwner.phone, address: shopOwner.address, role: shopOwner.role }
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// ✅ دوال إدارية
const getAllUsers = async (req, res) => {
  try {
    const users = await User.find().select('-password');
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getNormalUsers = async (req, res) => {
  try {
    const users = await User.find({ role: 'user' }).select('-password');
    res.json(users);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getShopOwners = async (req, res) => {
  try {
    const shopOwners = await User.find({ role: 'shopowner' }).select('-password');
    res.json(shopOwners);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const getUserById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id).select('-password');
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const updateUser = async (req, res) => {
  try {
    const { name, email, phone, address, role } = req.body;
    const user = await User.findByIdAndUpdate(req.params.id, { name, email, phone, address, role }, { new: true, runValidators: true }).select('-password');
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json({ message: 'User updated successfully', user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const deleteUser = async (req, res) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id);
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json({ message: 'User deleted successfully' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const makeAdmin = async (req, res) => {
  try {
    const user = await User.findByIdAndUpdate(req.params.id, { role: 'admin' }, { new: true });
    if (!user) return res.status(404).json({ error: 'User not found' });
    res.json({ message: 'User promoted to admin', user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

// ✅ تصدير كل الدوال
module.exports = {
  register,
  login,
  updateUserProfile,
  changePassword,
  createShopOwner,
  makeAdmin,
  getAllUsers,
  getShopOwners,
  getUserById,
  updateUser,
  deleteUser,
  getNormalUsers
};
