const jwt = require('jsonwebtoken');
require('dotenv').config();
const JWT_SECRET = process.env.JWT_SECRET;

const checkAuth = (req, res, next) => {
    const tokenParts = req.headers['authorization'].split(' ');
    if (tokenParts.length !== 2 || tokenParts[0] !== 'Bearer') {
        return res.status(401).json({ error: 'Authorization header format should be: Bearer [token]' });
    }
    const token = tokenParts[1];
    console.log("\n----------backend token in checkAuth " + token)

    jwt.verify(token, JWT_SECRET, (err, decoded) => {
        if (err) return res.status(401).json({ error: 'Invalid token', details: err.message });
        req.userId = decoded.userId;
        next();
    });
};

module.exports = checkAuth;
