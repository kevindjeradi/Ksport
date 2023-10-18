const mongoose = require('mongoose');

const exerciseSchema = new mongoose.Schema({
    muscleId: { type: mongoose.Schema.Types.ObjectId, ref: 'Muscle' },
    imageUrl: String,
    label: {
        type: String,
        unique: true  // <-- This ensures uniqueness
    },
    detailTitle: {
        type: String,
        unique: true  // <-- This ensures uniqueness
    },
    detailDescription: String
});

module.exports = mongoose.model('Exercise', exerciseSchema);
