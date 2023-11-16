// user.js
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const userSchema = new mongoose.Schema({
    username: {
        type: String,
        unique: true,
        required: true
    },
    password: {
        type: String,
        required: true
    },
    dateJoined: {
        type: Date,
        default: Date.now
    },
    profileImage: String,
    trainings: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Training' }],
    trainingsSchedule: {
        lundi: { type: mongoose.Schema.Types.ObjectId, ref: 'Training' },
        mardi: { type: mongoose.Schema.Types.ObjectId, ref: 'Training' },
        mercredi: { type: mongoose.Schema.Types.ObjectId, ref: 'Training' },
        jeudi: { type: mongoose.Schema.Types.ObjectId, ref: 'Training' },
        vendredi: { type: mongoose.Schema.Types.ObjectId, ref: 'Training' },
        samedi: { type: mongoose.Schema.Types.ObjectId, ref: 'Training' },
        dimanche: { type: mongoose.Schema.Types.ObjectId, ref: 'Training' },
    },
    settings: {
        theme: String,
    },
    history: {
        completedTrainings: [{
            trainingData: {
                name: String,
                description: String,
                exercises: [{
                    label: String,
                    exerciseId: { type: mongoose.Schema.Types.ObjectId, ref: 'Exercise' },
                    repetitions: [Number],
                    sets: Number,
                    weight: [Number],
                    restTime: [Number]  // in seconds
                }],
                goal: String,
            },
            dateCompleted: { type: Date, required: true },
            note: String,
        }],
    },
});


// Hash the password before saving
userSchema.pre('save', async function (next) {
    if (!this.isModified('password')) return next();
    const salt = await bcrypt.genSalt(10);
    this.password = await bcrypt.hash(this.password, salt);
    next();
});

// Method to check password
userSchema.methods.isCorrectPassword = async function (password) {
    return bcrypt.compare(password, this.password);
};

module.exports = mongoose.model('Users', userSchema);
