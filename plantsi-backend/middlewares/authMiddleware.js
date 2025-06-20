const jwt = require('jsonwebtoken');

/**
 * Middleware: التحقق من وجود توكن وصحته
 */
const isAuthenticated = (req, res, next) => {
  const rawHeader = req.header('Authorization');
  console.log("🔐 Incoming Authorization header:", rawHeader);

  const token = rawHeader?.replace('Bearer ', '');
  if (!token) {
    console.log("⛔ No token provided");
    return res.status(401).json({ error: "No token provided" });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    req.user = decoded;
    req.userId = decoded.id || decoded._id; // ⬅️ استخدم id أو _id أيًا كان موجود
    console.log("✅ Authenticated user:", decoded);

    next();
  } catch (err) {
    console.error("❌ Invalid token:", err.message);
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
 * Middleware: User only
 */
const userOnly = (req, res, next) => {
  if (req.user && req.user.role === 'user') {
    next();
  } else {
    res.status(403).json({ message: 'User access only' });
  }
};

/**
 * Middleware: User or ShopOwner only
 */
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
