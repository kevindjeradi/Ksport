const mongoose = require('mongoose');

const trainingSchema = new mongoose.Schema({
    name: { type: String, required: true },
    description: String,
    exercises: [{
        exerciseId: { type: mongoose.Schema.Types.ObjectId, ref: 'Exercise' },
        repetitions: Number,
        sets: Number,
        restTime: Number  // in seconds or minutes
    }],
    targetMuscle: String,
    goal: String
});