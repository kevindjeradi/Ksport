// userRoutes.js
const express = require('express');
const mongoose = require('mongoose');
const User = require('../models/User');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');
const path = require('path');
const checkAuth = require('../middleware/checkAuth');
const Training = require('../models/Training');


const router = express.Router();

require('dotenv').config();
const JWT_SECRET = process.env.JWT_SECRET;

// Configure multer for profile image upload
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'images/')
    },
    filename: function (req, file, cb) {
        const userId = req.userId;
        cb(null, `user_${userId}${path.extname(file.originalname)}`);
    }
})

const upload = multer({ storage: storage })

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

    const token = jwt.sign({ userId: user._id }, JWT_SECRET, { expiresIn: '30d' });
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
        const numberOfTrainings = user.trainings.length
        // Return the required details
        const userDetails = {
            username: user.username,
            dateJoined: user.dateJoined,
            profileImage: user.profileImage,
            numberOfTrainings: numberOfTrainings,
            theme: user.settings.theme,
            completedTrainings: user.history.completedTrainings,
        };
        res.json(userDetails);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Validate Token Route
router.post('/validate', async (req, res) => {
    try {
        const { token } = req.body;
        if (!token) {
            return res.status(401).json({ error: 'Token is required' });
        }

        // Verify the token
        const decoded = jwt.verify(token, JWT_SECRET);
        
        res.status(200).json({ valid: true, userId: decoded.userId });
    } catch (error) {
        res.status(401).json({ valid: false, error: 'Invalid Token' });
    }
});

// Route to set profile image for the first time
router.post('/user/profileImage', checkAuth, upload.single('profileImage'), async (req, res) => {
    try {
        const userId = req.userId;

        // Update the user's profileImage field using findOneAndUpdate
        const updatedUser = await User.findOneAndUpdate(
            { _id: userId },
            { $set: { profileImage: `/images/${req.file.filename}` } },
            { new: true } // This option returns the updated user document
        );

        if (!updatedUser) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.status(200).json({
            message: 'Profile image set successfully',
            profileImage: updatedUser.profileImage,
        });
    } catch (error) {
        console.error(error);
        console.log("error in post user/profileImage: " + error);
        res.status(500).json({ error: error.message });
    }
});

// Route to update profile image
router.patch('/user/profileImage', checkAuth, upload.single('profileImage'), async (req, res) => {
    try {
        const userId = req.userId;

        // Update the user's profileImage field using findOneAndUpdate
        const updatedUser = await User.findOneAndUpdate(
            { _id: userId },
            { $set: { profileImage: `/images/${req.file.filename}` } },
            { new: true } // This option returns the updated user document
        );

        if (!updatedUser) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.status(200).json({
            message: 'Profile image updated successfully',
            profileImage: updatedUser.profileImage,
        });
    } catch (error) {
        console.error(error);
        console.log("error in patch user/profileImage: " + error);
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

        if (!mongoose.Types.ObjectId.isValid(trainingId)) {
            return res.status(400).json({ error: 'Invalid trainingId format' });
        }

        const dayString = dayMapping[day - 1];
        if (!dayString) {
            console.error("Invalid day value:", day);
            return res.status(400).json({ error: 'Invalid day value' });
        }

        const updatePath = `trainingsSchedule.${dayString}`;
        const updatedUser = await User.findOneAndUpdate(
            { _id: userId },
            { $set: { [updatePath]: new mongoose.Types.ObjectId(trainingId) } },
            { new: true } // This option returns the updated user document
        );

        if (!updatedUser) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.status(200).json({ message: 'Training updated successfully', updatedUser });
    } catch (error) {
        console.log("error in updateTrainingForDay route: " + error);
        res.status(500).json({ error: error.message });
    }
});

  // Get a user's training for a specific day
router.get('/user/getTrainingForDay/:day', async (req, res) => {
    const day = req.params.day;

    try {
        const token = req.headers.authorization.split(' ')[1];

        const decoded = jwt.verify(token, JWT_SECRET);
        const userId = decoded.userId;
        const user = await User.findById(userId).populate(`trainingsSchedule.${day}`);
        if (user.trainingsSchedule[day])
        {
            return res.status(200).json(user.trainingsSchedule[day]);
        }
        return res.status(200).json({});
    } catch (error) {
        console.log("error in getTrainingForDay route")
        return res.status(500).json({ error: error.message });
    }
});

  // Delete a user's training for a specific day
router.delete('/user/deleteTrainingForDay/:day', async (req, res) => {
    const day = req.params.day;
    try {
        const token = req.headers.authorization.split(' ')[1];
        const decoded = jwt.verify(token, JWT_SECRET);
        const userId = decoded.userId;
        const user = await User.findById(userId);
        user.trainingsSchedule[day] = null;
        await user.save();
        res.status(200).json({ message: 'Training deleted successfully' });
    } catch (error) {
        console.log("\n\n-------------->user trainingsSchedule[day] -->" + user.trainingsSchedule[day])
        res.status(500).json({ error: error.message });
    }
});

router.patch('/user/updateTheme', async (req, res) => {
    try {
        const token = req.headers.authorization.split(' ')[1];
        const decoded = jwt.verify(token, JWT_SECRET);
        const userId = decoded.userId;
        const { theme } = req.body;

        // Update only the theme setting
        await User.findOneAndUpdate({ _id: userId }, { $set: { 'settings.theme': theme } });

        res.status(200).json({ message: 'Theme updated successfully' });
    } catch (error) {
        console.log("Updated theme error: " + error.message);
        res.status(500).json({ error: error.message });
    }
});

router.post('/user/recordCompletedTraining', async (req, res) => {
    try {
        const { trainingId, dateCompleted } = req.body;
        const token = req.headers.authorization.split(' ')[1];
        const decoded = jwt.verify(token, process.env.JWT_SECRET); // Replace with your JWT secret
        const userId = decoded.userId;

        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        if (!mongoose.Types.ObjectId.isValid(trainingId)) {
            return res.status(400).json({ error: 'Invalid trainingId format' });
        }

        const training = await Training.findById(trainingId);
        if (!training) {
            return res.status(404).json({ error: 'Training not found' });
        }

        const newCompletedTraining = { 
            trainingData: {
                name: training.name,
                description: training.description,
                exercises: training.exercises.map(ex => ({
                    label: ex.label,
                    exerciseId: ex.exerciseId,
                    repetitions: ex.repetitions,
                    sets: ex.sets,
                    weight: ex.weight,
                    restTime: ex.restTime
                })),
                goal: training.goal,
            },
            dateCompleted: new Date(dateCompleted) // assuming dateCompleted is in a valid format
        };

        user.history.completedTrainings.push(newCompletedTraining);
        await user.save();

        res.status(200).json({ message: 'Training recorded successfully' });
    } catch (error) {
        console.log("recordCompletedTraining error: " + error.message)
        res.status(500).json({ error: error.message });
    }
});
// PATCH route to update a note for a specific completed training
router.patch('/user/updateTrainingNote', checkAuth, async (req, res) => {
    try {
        const userId = req.userId;
        const { trainingId, note } = req.body;

        // Find the user and the specific training
        const user = await User.findById(userId);
        if (!user) {
            return res.status(404).json({ error: 'User not found' });
        }

        // Find the specific training to update the note
        const trainingIndex = user.history.completedTrainings.findIndex(t => t._id.toString() === trainingId);
        if (trainingIndex === -1) {
            return res.status(404).json({ error: 'Training not found' });
        }

        // Update the note for the training
        user.history.completedTrainings[trainingIndex].note = note;
        console.log("user.history.completedTrainings[trainingIndex].note -->" + user.history.completedTrainings[trainingIndex].note);
        console.log("completedTrainings[trainingIndex] -->" + user.history.completedTrainings[trainingIndex]);
        console.log("trainingIndex -->" + trainingIndex);
        await user.save();

        res.status(200).json({ message: 'Note updated successfully' });
    } catch (error) {
        console.log("Error in updateTrainingNote route: " + error.message);
        res.status(500).json({ error: error.message });
    }
});


module.exports = router;
