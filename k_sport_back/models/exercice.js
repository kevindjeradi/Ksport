const mongoose = require('mongoose');

const exerciseSchema = new mongoose.Schema({
    imageUrl: String,
    label: {
        type: String,
        unique: true  // <-- This ensures uniqueness
    },
    detailTitle: {
        type: String,
        unique: true  // <-- This ensures uniqueness
    },
    detailDescription: String,
    muscleLabel: { type: String, required: true }
});

module.exports = mongoose.model('Exercise', exerciseSchema);
