const express = require('express');
const User = require('../models/User');
const Training = require('../models/Training');

const router = express.Router();

// GET all trainings associated with the user
router.get('/trainings', async (req, res) => {
    try {
        const user = await User.findById(req.userId).populate('trainings'); // <-- Fetching the user and their trainings
        res.json(user.trainings);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// GET a specific training by ID
router.get('/trainings/:id', async (req, res) => {
    try {
        const training = await Training.findById(req.params.id);
        if (!training) return res.status(404).json({ message: 'Training not found' });
        res.json(training);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

router.post('/trainings', async (req, res) => {
    try {
        const { name, description, exercises } = req.body;

        // Validate name and description
        if (!name || !description) {
            return res.status(400).json({ error: "Name and Description are required." });
        }

        // Validate exercises
        if (!exercises || !Array.isArray(exercises) || exercises.length === 0) {
            return res.status(400).json({ error: "Exercises array is required and should not be empty." });
        }

        for (let exercise of exercises) {
            // Validate the exerciseId
            if (!exercise.exerciseId) {
                return res.status(400).json({ error: "Exercise ID is required." });
            }
            
            // Validate sets
            if (typeof exercise.sets !== "number" || exercise.sets <= 0) {
                return res.status(400).json({ error: "Invalid number of sets." });
            }

            // Validate repetitions as an array of numbers
            if (!Array.isArray(exercise.repetitions) || exercise.repetitions.some(rep => typeof rep !== "number" || rep <= 0)) {
                return res.status(400).json({ error: "Invalid repetitions data. Each repetition must be a number greater than 0." });
            }
            
            // Validate restTime
            if (typeof exercise.restTime !== "number" || exercise.restTime <= 0) {
                return res.status(400).json({ error: "Invalid rest time." });
            }
        }

        const training = new Training(req.body);
        const savedTraining = await training.save();
        
        // Now associate this training with the logged-in user
        const user = await User.findById(req.userId);
        user.trainings.push(savedTraining._id);
        await user.save();
        
        res.status(201).json(savedTraining);
    } catch (error) {
        if (error.code && error.code === 11000) {
            return res.status(400).json({ error: 'This training name already exists.' });
        }
        res.status(500).json({ error: error.message });
    }
});


// PUT (update) a training by ID
router.put('/trainings/:id', async (req, res) => {
    try {
        const training = await Training.findById(req.params.id);
        if (!training) return res.status(404).json({ message: 'Training not found' });

        // Check if the training belongs to the authenticated user
        const user = await User.findById(req.userId);
        if (!user.trainings.some(trainingId => trainingId.equals(training._id))) {
            return res.status(403).json({ message: 'You do not have permission to update this training' });
        }

        // Proceed to update the training
        const updatedTraining = await Training.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.json(updatedTraining);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// DELETE a training by ID
router.delete('/trainings/:id', async (req, res) => {
    try {
        const deletedTraining = await Training.findByIdAndDelete(req.params.id);
        if (!deletedTraining) return res.status(404).json({ message: 'Training not found' });

        // Remove the training reference from the user's trainings array
        const user = await User.findById(req.userId);
        user.trainings = user.trainings.filter(trainingId => !trainingId.equals(deletedTraining._id));
        await user.save();
        console.log("deleted training : " + deletedTraining._id)
        res.json({ message: 'Training deleted' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
