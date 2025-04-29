const jwt = require('jsonwebtoken');

exports.auth = (req, res, next) => {
  const token = req.header('Authorization')?.replace('Bearer ', '');
  if (!token) return res.status(401).json({ msg: 'No token, authorization denied' });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded; // { userId, role }
    next();
  } catch (err) {
    res.status(401).json({ msg: 'Token is not valid', error: err.message  });
  }
};

// Role-based access control
exports.authorizeRoles = (...roles) => (req, res, next) => {
  console.log(req.user.role)
  if (!roles.includes(req.user.role)) {
    return res.status(403).json({ msg: 'Access denied: insufficient permissions' });
  }
  next();
};