import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:k_sport_front/helpers/logger.dart';

class NotificationProvider {
  static Future<bool> setupNotification() async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    try {
      FirebaseMessaging.instance.getToken().then((token) {
        Log.logger.i("FCM Token: $token");
      });

      await firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      return true;
    } catch (e) {
      Log.logger.e(e.toString());
      return false;
    }
  }

  static Future<bool> registerTopic({required String topic}) async {
    final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

    try {
      await firebaseMessaging
          .subscribeToTopic(topic)
          .onError((error, stackTrace) => Log.logger.e(error.toString()))
          .then((value) => Log.logger.i("Subscribed to $topic"));
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
