// main.dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:k_sport_front/helpers/auth_check.dart';
import 'package:k_sport_front/helpers/locale_notification_handler.dart';
import 'package:k_sport_front/helpers/logger.dart';
import 'package:k_sport_front/provider/auth_provider.dart';
import 'package:k_sport_front/provider/notification_provider.dart';
import 'package:k_sport_front/provider/schedule_training_provider.dart';
import 'package:k_sport_front/provider/theme_color_scheme_provider.dart';
import 'package:k_sport_front/provider/user_provider.dart';
import 'package:k_sport_front/theme/theme_light.dart';
import 'package:k_sport_front/views/auth/login_page.dart';
import 'package:k_sport_front/views/auth/register_page.dart';
import 'package:k_sport_front/views/home.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  NotificationProvider.setupNotification();
  NotificationProvider.registerTopic(topic: "everyone");

  await dotenv.load(fileName: ".env");

  Log.logger.i("Trying to configure LocalTimeZone");
  await _configureLocalTimeZone();

  Log.logger.i("Trying to initialize flutter locale notifications");
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('hakedj');

  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {},
  );

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      Log.logger.i(
          "Received notification response -> notification id: ${notificationResponse.id}");
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );

  _isAndroidPermissionGranted();

  final notificationHandler =
      LocaleNotificationHandler(flutterLocalNotificationsPlugin);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeColorSchemeProvider()),
        Provider<LocaleNotificationHandler>.value(value: notificationHandler),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => ScheduleTrainingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    handleIncomingNotification();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeColorSchemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'K Sports',
      theme: themeLight(themeProvider.colorScheme, themeProvider.textTheme),
      themeMode: ThemeMode.light,
      home: const AuthCheck(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const Home(),
      },
    );
  }

  Future<void> handleIncomingNotification() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    RemoteMessage? incomingNotification =
        await FirebaseMessaging.instance.getInitialMessage();

    if (incomingNotification != null) {
      Log.logger.i(incomingNotification.notification?.body ?? 'empty');
      handlePushNotificationData(incomingNotification);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(handlePushNotificationData);
  }

  void handlePushNotificationData(RemoteMessage notification) {
    Log.logger.i('handleIncomingNogification -> notification: $notification');
  }
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  Log.logger.i("timeZoneName: $timeZoneName");
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

void notificationTapBackground(NotificationResponse notificationResponse) {
  Log.logger.i('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    Log.logger.i(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

Future<void> _isAndroidPermissionGranted() async {
  final bool granted = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled() ??
      false;

  Log.logger.i("is android permission granted: $granted");

  final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
      flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

  if (!granted) {
    await androidImplementation?.requestNotificationsPermission();
  }
}
