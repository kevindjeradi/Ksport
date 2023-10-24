const express = require('express');
const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

const router = express.Router();

require('dotenv').config();
const JWT_SECRET = process.env.JWT_SECRET;

router.post('/signup', async (req, res) => {
    try {
        const { username, password } = req.body;
        
        // Check if user with the same username already exists
        const existingUser = await User.findOne({ username });
        if (existingUser) {
            return res.status(400).json({ error: 'Username already exists' });
        }
        
        const user = new User({ username, password });
        await user.save();

        // Generate token after successful registration
        const token = jwt.sign({ userId: user._id }, JWT_SECRET, { expiresIn: '1h' });

        res.status(201).json({ message: 'User created successfully', token });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

router.post('/login', async (req, res) => {
    const { username, password } = req.body;
    const user = await User.findOne({ username });
    if (!user || !await user.isCorrectPassword(password)) {
        return res.status(401).json({ error: 'Invalid username or password' });
    }

    const token = jwt.sign({ userId: user._id }, JWT_SECRET, { expiresIn: '1h' });
    res.json({ token });
});

router.get('/user/details', async (req, res) => {
    // Verify the token and extract the userId
    try {
        const token = req.headers.authorization.split(' ')[1];
        const decoded = jwt.verify(token, JWT_SECRET);
        const userId = decoded.userId;

        // Find the user by their ID
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        // Return the required details
        const userDetails = {
            username: user.username,
            dateJoined: user.dateJoined,
            profileImage: user.profileImage
        };
        res.json(userDetails);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Update a specific day's training for a user
router.put('/user/schedule/:day', async (req, res) => {
    try {
        const token = req.headers.authorization.split(' ')[1];
        const decoded = jwt.verify(token, JWT_SECRET);
        const userId = decoded.userId;

        const day = req.params.day;
        const { trainingId } = req.body;

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        user.trainingsSchedule[day] = trainingId;
        await user.save();

        res.json({ message: "Updated successfully" });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Fetch user's training schedule
router.get('/user/schedule', async (req, res) => {
    try {
        const token = req.headers.authorization.split(' ')[1];
        const decoded = jwt.verify(token, JWT_SECRET);
        const userId = decoded.userId;

        const user = await User.findById(userId).populate('trainingsSchedule.lundi').populate('trainingsSchedule.mardi')...; // populate for other days
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.json(user.trainingsSchedule);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


module.exports = router;
