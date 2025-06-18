const jwt = require('jsonwebtoken');

/**
 * Middleware: التحقق من وجود توكن وصحته
 */
const isAuthenticated = (req, res, next) => {
  const token = req.header('Authorization')?.replace('Bearer ', '');
  if (!token) {
    return res.status(401).json({ error: "No token provided" });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded;
    req.userId = decoded.id; // مهم جدًا للربط مع الطلبات
    next();
  } catch (err) {
    res.status(400).json({ error: "Invalid token" });
  }
};

/**
 * Middleware: Admin only
 */
const adminOnly = (req, res, next) => {
  if (req.user && req.user.role === 'admin') {
    next();
  } else {
    res.status(403).json({ message: 'Admin access only' });
  }
};

/**
 * Middleware: ShopOwner only
 */
const shopOwnerOnly = (req, res, next) => {
  if (req.user && req.user.role === 'shopowner') {
    next();
  } else {
    res.status(403).json({ message: 'ShopOwner access only' });
  }
};

/**
 * Middleware: User only (لو بدك يقدر user يعمل اشي معين)
 */
const userOnly = (req, res, next) => {
  if (req.user && req.user.role === 'user') {
    next();
  } else {
    res.status(403).json({ message: 'User access only' });
  }
};

const userOrShopOwner = (req, res, next) => {
  if (req.user && (req.user.role === 'user' || req.user.role === 'shopowner')) {
    next();
  } else {
    res.status(403).json({ message: 'User or ShopOwner access only' });
  }
};


module.exports = {
  isAuthenticated,
  adminOnly,
  shopOwnerOnly,
  userOnly,
  userOrShopOwner
};
