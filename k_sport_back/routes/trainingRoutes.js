const express = require('express');
const Training = require('../models/Training');

const router = express.Router();

// GET all trainings
router.get('/trainings', async (req, res) => {
    try {
        const trainings = await Training.find();
        res.json(trainings);
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

// POST (create) a new training
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
            if (!exercise.exerciseId || typeof exercise.repetitions !== "number" || exercise.repetitions <= 0 ||
                typeof exercise.sets !== "number" || exercise.sets <= 0 ||
                typeof exercise.restTime !== "number" || exercise.restTime <= 0) {
                return res.status(400).json({ error: "Invalid exercise data." });
            }
        }

        const training = new Training(req.body);
        const savedTraining = await training.save();
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
        const updatedTraining = await Training.findByIdAndUpdate(req.params.id, req.body, { new: true });
        if (!updatedTraining) return res.status(404).json({ message: 'Training not found' });
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
        res.json({ message: 'Training deleted' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;