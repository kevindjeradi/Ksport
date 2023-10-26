const express = require('express');
const mongoose = require('mongoose');
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

// Update a user's training for a specific day
router.post('/user/updateTrainingForDay', async (req, res) => {
    const { day, trainingId } = req.body;
    const dayMapping = {
        0: 'lundi',
        1: 'mardi',
        2: 'mercredi',
        3: 'jeudi',
        4: 'vendredi',
        5: 'samedi',
        6: 'dimanche'
    };
    try {
        const token = req.headers.authorization.split(' ')[1];
        const decoded = jwt.verify(token, JWT_SECRET);
        const userId = decoded.userId;
        const user = await User.findById(userId);

        if (!mongoose.Types.ObjectId.isValid(trainingId)) {
            return res.status(400).json({ error: 'Invalid trainingId format' });
        }
        console.log("Day:", day);
        console.log("Training ID:", trainingId);
        console.log("Updated User:", user);
        const dayString = dayMapping[day - 1];
        console.log("DayString:", dayString);
        if (dayString) 
        {
            user.trainingsSchedule[dayString] = new mongoose.Types.ObjectId(trainingId);
            user.markModified('trainingsSchedule');
            await user.save();
            const updatedUser = await User.findById(userId);
            console.log("training of user After Update:", updatedUser.trainings);
        }
        else {
            console.error("Invalid day value:", day);
        }
        res.status(200).json({ message: 'Training updated successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

  // Get a user's training for a specific day
router.get('/user/getTrainingForDay/:day', async (req, res) => {
    const day = req.params.day;

    try {
        const token = req.headers.authorization.split(' ')[1];
        console.log("------------------token in getTrainingForDay route " + token)

        const decoded = jwt.verify(token, JWT_SECRET);
        const userId = decoded.userId;
        const user = await User.findById(userId).populate(`trainingsSchedule.${day}`);
        console.log("in get /user/getTrainingForDay/:day --> day = " + day + "------------------user trainingsSchedule[day] --> " + user.trainingsSchedule[day])
        if (user.trainingsSchedule[day])
        {
            res.status(200).json(user.trainingsSchedule[day]);
        }
        res.status(200).json({});
    } catch (error) {
        console.log("error in getTrainingForDay route")
        res.status(500).json({ error: error.message });
    }
});

  // Delete a user's training for a specific day
router.delete('/user/deleteTrainingForDay/:day', async (req, res) => {
    const day = req.params.day;
    try {
        const token = req.headers.authorization.split(' ')[1];
        print("------------------token in delete route " + token)
        const decoded = jwt.verify(token, JWT_SECRET);
        const userId = decoded.userId;
        const user = await User.findById(userId);
        user.trainingsSchedule[day] = null;
        await user.save();
        res.status(200).json({ message: 'Training deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
