// notifRoutes.js
const express = require('express');
const router = express.Router();
const admin = require('firebase-admin');

// POST route for sending a notification to multiple users
router.post('/send-notification-to-users', (req, res) => {
    const { tokens, title, body } = req.body; // 'tokens' should be an array
  
    // Create an array of messages, one for each token
    const messages = tokens.map(token => {
      return {
        notification: {
          title: title,
          body: body
        },
        token: token
      };
    });
  
    admin.messaging().sendAll(messages)
      .then((response) => {
        console.log('Successfully sent messages:', response);
        res.status(200).send(`Notifications sent successfully to ${response.successCount} users`);
      })
      .catch((error) => {
        console.log('Error sending messages:', error);
        res.status(500).send('Failed to send notifications');
      });
  });

// POST route for sending a notification to a topic
router.post('/send-notification-to-topic', (req, res) => {
    const { topic, title, body } = req.body;
  
    const message = {
      notification: {
        title: title,
        body: body,
      },
      data: {
        title: title,
        body: body,
      },
      topic: topic
    };

    admin.messaging().send(message)
      .then((response) => {
        console.log('Successfully sent message:', response);
        res.status(200).send(`Notification sent successfully to topic ${topic}`);
      })
      .catch((error) => {
        console.log('Error sending message:', error);
        res.status(500).send('Failed to send notification to topic');
      });
  });

module.exports = router;
