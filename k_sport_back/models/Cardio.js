const mongoose = require('mongoose');

const cardioSchema = new mongoose.Schema({
    userId: { type: mongoose.Schema.Types.ObjectId, ref: 'Users', required: true },
    exerciseName: { type: String, required: true },
    duration: { type: Number, required: true },
    date: { type: Date, required: true },
    // Common fields
    calories: { type: Number },
    note: { type: String },
    
    // Vélo specific fields
    averageWatts: { type: Number },
    distance: { type: Number },
    cadence: { type: Number },
    averageSpeed: { type: Number },
    averageBpm: { type: Number },
    maxBpm: { type: Number },
    
    // Rameur specific fields
    split500m: { type: String },  // Format: mm:ss
    strokesPerMinute: { type: Number },
    
    // Escalier specific fields
    floors: { type: Number },
    
    // Course specific fields
    pace: { type: String },  // Format: mm:ss/km
    elevation: { type: Number }
});

// Add validation for split500m and pace format (mm:ss)
const timeFormatRegex = /^([0-5][0-9]):([0-5][0-9])$/;

cardioSchema.path('split500m').validate(function(value) {
    if (!value) return true; // Allow empty values
    return timeFormatRegex.test(value);
}, 'Invalid split500m format. Must be mm:ss');

cardioSchema.path('pace').validate(function(value) {
    if (!value) return true; // Allow empty values
    return timeFormatRegex.test(value);
}, 'Invalid pace format. Must be mm:ss');

module.exports = mongoose.model('Cardio', cardioSchema);