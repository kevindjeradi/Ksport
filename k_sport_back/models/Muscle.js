// muscle.js
const mongoose = require('mongoose');

const muscleSchema = new mongoose.Schema({
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
    groupe: String,
});


module.exports = mongoose.model('Muscle', muscleSchema);
