const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');



// تسجيل مستخدم جديد
const register = async (req, res) => {
  try {
    const { name, email, phone, address, password } = req.body;

    // التحقق من وجود المستخدم بالبريد
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
      phone,
      address,
      password: hashedPassword,
      role: 'user'  // إجباري يكون user عند التسجيل
    });

    await user.save();

    // إنشاء JWT
    const token = jwt.sign(
      { id: user._id, role: user.role },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );

    res.status(201).json({
      message: "User registered successfully",
      token,
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        phone: user.phone,
        address: user.address,
        role: user.role
      }
    });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }

};
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
        phone: user.phone,
        address: user.address,
        role: user.role
      }
    });

  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};



// إنشاء Shop Owner
const createShopOwner = async (req, res) => {
  try {
    const { name, email, phone, address, password } = req.body;

    // التأكد إذا المستخدم موجود بالبريد
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: "Email already exists" });
    }

    // تشفير كلمة المرور
    const hashedPassword = await bcrypt.hash(password, 12);

    // إنشاء مستخدم برول shopowner
    const shopOwner = new User({
      name,
      email,
      phone,
      address,
      password: hashedPassword,
      role: 'shopowner'
    });

    await shopOwner.save();

    res.status(201).json({
      message: "Shop owner created successfully",
      shopOwner: {
        id: shopOwner._id,
        name: shopOwner.name,
        email: shopOwner.email,
        phone: shopOwner.phone,
        address: shopOwner.address,
        role: shopOwner.role
      }
    });

  } catch (err) {
    res.status(500).json({ error: err.message });
  } 
};
const getAllUsers = async (req, res) => {
  try {
    const users = await User.find().select('-password'); // استبعاد كلمة المرور
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
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json(user);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const updateUser = async (req, res) => {
  try {
    const { name, email, phone, address, role } = req.body;

    const user = await User.findByIdAndUpdate(
      req.params.id,
      { name, email, phone, address, role },
      { new: true, runValidators: true }
    ).select('-password');

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    res.json({ message: "User updated successfully", user });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
};

const deleteUser = async (req, res) => {
  try {
    const user = await User.findByIdAndDelete(req.params.id);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    res.json({ message: "User deleted successfully" });
  } catch (err) {
    res.status(500).json({ error: err.message });
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



module.exports = {
  register,
  login,
  createShopOwner,
  makeAdmin,
  getAllUsers,
  getShopOwners,
  getUserById,
  updateUser,
  deleteUser
};
