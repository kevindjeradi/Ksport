const jwt = require('jsonwebtoken');

const checkAuth = (req, res, next) => {
    const token = req.headers['authorization'];
    if (!token) return res.status(401).json({ error: 'Authorization required' });

    jwt.verify(token, process.env.JWT_SECRET, (err, decoded) => {
        if (err) return res.status(401).json({ error: 'Invalid token' });
        req.userId = decoded.userId;
        next();
    });
};

module.exports = checkAuth;
