const express = require('express');
const cors = require('cors');
const workoutRoutes = require('./routes/workoutRoutes');

const app = express();
const PORT = 3000;

app.use(cors({
    origin: '*'
}));

app.use('/', workoutRoutes);

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
});