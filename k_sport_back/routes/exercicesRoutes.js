// exercicesRoutes.js
const express = require('express');
const Exercise = require('../models/Exercice');

const router = express.Router();

// GET all exercises or filter by muscleLabel
router.get('/exercises', async (req, res) => {
    try {
        const query = {};

        // If muscleLabel is provided in the query, filter by it
        if (req.query.muscleLabel) {
            query.muscleLabel = req.query.muscleLabel;
        }

        const exercises = await Exercise.find(query);  // Use the query object to filter results
        res.json(exercises);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// GET a specific exercise
router.get('/exercises/:id', async (req, res) => {
    try {
        const exercise = await Exercise.findById(req.params.id);
        if (!exercise) return res.status(404).json({ message: 'Exercise not found' });
        res.status(200).json(exercise);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// GET an exercise by label
router.get('/exercises/label/:label', async (req, res) => {
    try {
        const exercise = await Exercise.findOne({ label: req.params.label });
        if (!exercise) return res.status(404).json({ message: 'Exercise not found' });
        res.status(200).json(exercise);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});


// POST (create) a new exercise
router.post('/exercises', async (req, res) => {
    try {
        const exercise = new Exercise(req.body);
        const savedExercise = await exercise.save();
        res.status(201).json(savedExercise);
    } catch (error) {
        if (error.code && error.code === 11000) {
            return res.status(400).json({ error: 'This exercise label already exists.' });
        }
        res.status(500).json({ error: error.message });
    }
});

// PUT (update) an exercise
router.put('/exercises/:id', async (req, res) => {
    try {
        const updatedExercise = await Exercise.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.json(updatedExercise);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// DELETE an exercise
router.delete('/exercises/:id', async (req, res) => {
    try {
        await Exercise.findByIdAndDelete(req.params.id);
        res.json({ message: 'Exercise deleted' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
