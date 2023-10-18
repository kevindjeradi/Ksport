const express = require('express');
const router = express.Router();

const workouts = [
    {
        id: 1,
        imageUrl: 'https://via.placeholder.com/500x500',
        label: 'Quadriceps',
        detailTitle: 'Quadriceps',
        detailDescription: 'Description',
    },
    {
        id: 2,
        imageUrl: 'https://via.placeholder.com/500x500',
        label: 'Biceps',
        detailTitle: 'Biceps',
        detailDescription: 'Description',
    },
    {
        id: 3,
        imageUrl: 'https://via.placeholder.com/500x500',
        label: 'Ischios',
        detailTitle: 'Ischios',
        detailDescription: 'Description',
    },
    {
        id: 4,
        imageUrl: 'https://via.placeholder.com/500x500',
        label: 'Triceps',
        detailTitle: 'Triceps',
        detailDescription: 'Description',
    },
    {
        id: 5,
        imageUrl: 'https://via.placeholder.com/500x500',
        label: 'Deltoides',
        detailTitle: 'Deltoides',
        detailDescription: 'Description',
    },
    {
        id: 6,
        imageUrl: 'https://via.placeholder.com/500x500',
        label: 'Abdos',
        detailTitle: 'Abdos',
        detailDescription: 'Description',
    },
    ];

router.get('/workouts', (req, res) => {
  res.json(workouts);
});

module.exports = router;
