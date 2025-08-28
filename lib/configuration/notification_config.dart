// import 'dart:io';
//
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:reachify_app/utils/const/logger.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
//
//
// @pragma('vm:entry-point')
// void selectNotification(NotificationResponse response) async {
//   logger.d('Notification Payload:${response.payload}');
// }
//
//
// class NotificationServices {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   static final FirebaseMessaging _firebaseMessaging =
//       FirebaseMessaging.instance;
//
//   /// set icon path here
//   static const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   static const DarwinInitializationSettings initializationSettingsIOS =
//       DarwinInitializationSettings(
//     requestSoundPermission: true,
//     requestBadgePermission: true,
//     requestAlertPermission: true,
//   );
//
//   static const DarwinInitializationSettings initializationSettingsMacOS =
//       DarwinInitializationSettings(
//     requestAlertPermission: true,
//     requestBadgePermission: true,
//     requestSoundPermission: true,
//   );
//
//   static const InitializationSettings initializationSettings =
//       InitializationSettings(
//     android: initializationSettingsAndroid,
//     iOS: initializationSettingsIOS,
//     macOS: initializationSettingsMacOS,
//   );
//
//   static const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     'notification_channel',
//     'your_channel_name',
//     channelDescription: 'your_channel_description',
//     importance: Importance.max,
//     priority: Priority.high,
//     ticker: 'ticker',
//     icon: '@mipmap/ic_launcher',
//   );
//
//   static const ios = DarwinNotificationDetails(
//     interruptionLevel: InterruptionLevel.timeSensitive,
//   );
//
//   static const NotificationDetails platformChannelSpecifics =
//       NotificationDetails(
//           android: androidPlatformChannelSpecifics, iOS: ios, macOS: ios);
//
//   static Future<void> notificationRequest() async {
//     if (Platform.isIOS || Platform.isMacOS) {
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               IOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(
//             alert: true,
//             badge: true,
//             sound: true,
//           );
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               MacOSFlutterLocalNotificationsPlugin>()
//           ?.requestPermissions(
//             alert: true,
//             badge: true,
//             sound: true,
//           );
//     } else if (Platform.isAndroid) {
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//               AndroidFlutterLocalNotificationsPlugin>()
//           ?.requestNotificationsPermission();
//     }
//   }
//
//   static Future<void> initNotification() async {
//     try {
//       tz.initializeTimeZones();
//       // toast('Local notification initialize');
//       await flutterLocalNotificationsPlugin.initialize(
//         initializationSettings,
//         onDidReceiveBackgroundNotificationResponse: selectNotification,
//         onDidReceiveNotificationResponse: selectNotification,
//       );
//       logger.d('NOTIFICATION INIT');
//       // toast('Notification Req Called');
//       await notificationRequest();
//       // toast('Notification Request Complete');
//       if (Platform.isIOS) {
//         // toast('getNotificationAppLaunchDetails Called');
//         final NotificationAppLaunchDetails? details =
//             await flutterLocalNotificationsPlugin
//                 .getNotificationAppLaunchDetails();
//         if (details != null && details.notificationResponse != null) {
//           // logger.d(
//           //     "Notification Message :${details.notificationResponse?.payload}");
//           selectNotification(details.notificationResponse!);
//         }
//         await flutterLocalNotificationsPlugin.cancelAll();
//       }
//       // toast('FirebaseMessaging.onMessage Called');
//
//
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//         final RemoteNotification? notification = message.notification;
//
//         if (notification != null) {
//           showNotification(
//             id: notification.hashCode,
//             title: notification.title ?? 'No Title',
//             body: notification.body ?? 'No Body',
//             // payload: message.data['payload'] ?? '',
//             payload: message.data['app_redirection'] ?? '',
//           );
//         }
//       });
//       final res = await FirebaseMessaging.instance.getInitialMessage();
//       if (res != null) {
//         logger.d('Notification Details :${res.toMap()}');
//         selectNotification(
//           NotificationResponse(
//             id: res.messageId.hashCode,
//             payload: res.data['app_redirection'],
//             input: '',
//             actionId: '',
//             notificationResponseType:
//                 NotificationResponseType.selectedNotificationAction,
//           ),
//         );
//       }
//     } catch (e, t) {
//       logger.e('Error On Init Notification Function :$e', stackTrace: t);
//     }
//   }
//
//   static Future<String?> getToken() async {
//     try {
//       if (!Platform.isWindows) {
//         final res = await _firebaseMessaging.getToken();
//         // logger.d('Response :$res');
//         return res;
//         // return await _firebaseMessaging.getToken();
//       } else {
//         return 'N/A';
//       }
//     } on Exception catch (e) {
//       logger.d('Error Found on get FCM TOKEN :$e');
//       return 'N/A';
//     }
//   }
//
//   // static Future<void> updateTokens() async {
//   //   if (Platform.isIOS || Platform.isAndroid || Platform.isMacOS) {
//   //     String? fcmToken = await _firebaseMessaging.getToken();
//   //     logger.d('FCM Token: $fcmToken');
//   //
//   //     // Get the device ID
//   //     String deviceId = await DeviceInfoService.getDeviceId();
//   //     // logger.d('Device ID: $deviceId');
//   //   }
//   // }
//
//   static Future<void> removeNotification({required int id}) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }
//
//   static Future<void> scheduleNotifications({
//     required int id,
//     required String title,
//     required String body,
//     required DateTime scheduledTime,
//     required String payload,
//   }) async {
//     try {
//       final time = tz.TZDateTime.from(scheduledTime, tz.local);
//       logger.d(
//           'Notification ID $id \nTitle :$title \nBody :$body \nPayload :$payload');
//       await flutterLocalNotificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         time,
//         platformChannelSpecifics,
//         payload: payload,
//         androidScheduleMode: AndroidScheduleMode.alarmClock,
//         // uiLocalNotificationDateInterpretation:
//         //     UILocalNotificationDateInterpretation.absoluteTime,
//       );
//     } catch (e, t) {
//       logger.e('Notification Error :$e \n Trace :$t');
//     }
//   }
//
//   static Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     String? payload,
//   }) async {
//     try {
//       logger.d(
//           'Notification ID $id \nTitle :$title \nBody :$body \nPayload :$payload');
//       await flutterLocalNotificationsPlugin.show(
//         id,
//         title,
//         body,
//         platformChannelSpecifics,
//         payload: payload,
//       );
//     } catch (e, t) {
//       logger.e('Error :$e \n Trace :$t');
//     }
//   }
// }
