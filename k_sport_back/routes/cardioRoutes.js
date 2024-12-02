const express = require('express');
const router = express.Router();
const Cardio = require('../models/Cardio');
const checkAuth = require('../middleware/checkAuth');

// Get all cardio sessions for the authenticated user
router.get('/cardio-sessions', checkAuth, async (req, res) => {
    try {
        const sessions = await Cardio.find({ userId: req.userId })
            .sort({ date: -1 }); // Sort by date descending
        res.json(sessions);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Get a specific cardio session
router.get('/cardio-sessions/:id', checkAuth, async (req, res) => {
    try {
        const session = await Cardio.findOne({
            _id: req.params.id,
            userId: req.userId
        });
        if (!session) {
            return res.status(404).json({ message: 'Session not found' });
        }
        res.json(session);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Create a new cardio session
router.post('/cardio-sessions', checkAuth, async (req, res) => {
    try {
        const sessionData = {
            ...req.body,
            userId: req.userId,
            date: new Date(req.body.date)
        };

        const session = new Cardio(sessionData);
        const savedSession = await session.save();
        res.status(201).json(savedSession);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Update a cardio session
router.put('/cardio-sessions/:id', checkAuth, async (req, res) => {
    try {
        const session = await Cardio.findOneAndUpdate(
            { _id: req.params.id, userId: req.userId },
            req.body,
            { new: true }
        );
        if (!session) {
            return res.status(404).json({ message: 'Session not found' });
        }
        res.json(session);
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

// Delete a cardio session
router.delete('/cardio-sessions/:id', checkAuth, async (req, res) => {
    try {
        const session = await Cardio.findOneAndDelete({
            _id: req.params.id,
            userId: req.userId
        });
        if (!session) {
            return res.status(404).json({ message: 'Session not found' });
        }
        res.json({ message: 'Session deleted successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
});

router.patch('/cardio/updateNote', checkAuth, async (req, res) => {
    try {
        const { sessionId, note } = req.body;
        const userId = req.userId;

        const updatedSession = await Cardio.findOneAndUpdate(
            { _id: sessionId, userId: userId },
            { $set: { note: note } },
            { new: true }
        );

        if (!updatedSession) {
            return res.status(404).json({ error: 'Session not found' });
        }

        res.status(200).json({ message: 'Note updated successfully' });
    } catch (error) {
        console.error('Error updating cardio note:', error);
        res.status(500).json({ error: error.message });
    }
});

module.exports = router;