// training.js
const mongoose = require('mongoose');

const trainingSchema = new mongoose.Schema({
    name: { type: String, required: true },
    description: String,
    exercises: [{
        label: String,
        exerciseId: { type: mongoose.Schema.Types.ObjectId, ref: 'Exercise' },
        repetitions: Number,
        sets: Number,
        weight: Number,
        restTime: Number  // in seconds
    }],
    goal: String
});
module.exports = mongoose.model('Training', trainingSchema);
