const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const musclesRoutes = require('./routes/musclesRoutes');
const exercicesRoutes = require('./routes/exercicesRoutes');
const trainingRoutes = require('./routes/trainingRoutes');

const app = express();
const PORT = 3000;

// Load environment variables from .env file
require('dotenv').config();
const dbURI = process.env.MONGO_URI;

mongoose.connect(dbURI, {
    useNewUrlParser: true,
    useUnifiedTopology: true
})
.then(() => console.log('Connected to MongoDB'))
.catch(err => console.error('Could not connect to MongoDB', err));

app.use(cors());
app.use(express.json());
app.use('/', musclesRoutes);
app.use('/', exercicesRoutes);
app.use('/', trainingRoutes);

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});