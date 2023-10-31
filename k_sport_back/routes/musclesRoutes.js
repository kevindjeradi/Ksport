// musclesRoutes.js
const express = require('express');
const Muscle = require('../models/Muscle');

const router = express.Router();

// GET all muscles
router.get('/muscles', async (req, res) => {
    try {
        const muscles = await Muscle.find();
        res.json(muscles);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// GET a specific muscle
router.get('/muscles/:id', async (req, res) => {
    try {
        const muscle = await Muscle.findById(req.params.id);
        if (!muscle) return res.status(404).json({ message: 'Muscle not found' });
        res.json(muscle);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// POST (create) a new muscle
router.post('/muscles', async (req, res) => {
    try {
        const muscle = new Muscle(req.body);
        const savedMuscle = await muscle.save();
        res.status(201).json(savedMuscle);
    } catch (error) {
        if (error.code && error.code === 11000) {
            return res.status(400).json({ error: 'This muscle label already exists.' });
        }
        res.status(500).json({ error: error.message });
    }
});

// PUT (update) a muscle
router.put('/muscles/:id', async (req, res) => {
    try {
        const updatedMuscle = await Muscle.findByIdAndUpdate(req.params.id, req.body, { new: true });
        res.json(updatedMuscle);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// DELETE a muscle
router.delete('/muscles/:id', async (req, res) => {
    try {
        await Muscle.findByIdAndDelete(req.params.id);
        res.json({ message: 'Muscle deleted' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;
