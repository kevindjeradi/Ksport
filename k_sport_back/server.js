// server.js
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const path = require('path');
const admin = require('firebase-admin');
const serviceAccount = require('./k-sport-mobile-69cbd-firebase-adminsdk-7jlly-0b3a3fd20a.json');
const checkAuth = require('./middleware/checkAuth');
const musclesRoutes = require('./routes/musclesRoutes');
const exercicesRoutes = require('./routes/exercicesRoutes');
const trainingRoutes = require('./routes/trainingRoutes');
const notifRoutes = require('./routes/notifRoutes');
const userRoutes = require('./routes/userRoutes');

const app = express();
const PORT = 3001;

// Load environment variables from .env file
require('dotenv').config();
const dbURI = process.env.MONGO_URI;
const JWT_SECRET = process.env.JWT_SECRET;

mongoose.connect(dbURI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
})
.then(() => console.log('Connected to MongoDB'))
.catch(err => console.error('Could not connect to MongoDB', err));

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

app.use(cors());
app.use(express.json());

app.use('/images', express.static(path.join(__dirname, 'images')));

app.use('/', userRoutes);
app.use('/', musclesRoutes);
app.use('/', exercicesRoutes);
app.use('/', checkAuth, trainingRoutes);
app.use('/', notifRoutes);

app.listen(PORT, '0.0.0.0', function() {
  console.log(`Server is running on http://localhost:${PORT}`);
}
);
