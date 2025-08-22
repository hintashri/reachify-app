// import 'dart:convert';
// import 'dart:io';
// import 'package:reachify_app/utils/const/logger.dart';
//
// class NotificationConfig {
//   static final FlutterLocalNotificationsPlugin notificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//
//   static var android = const AndroidNotificationDetails(
//     'channel id', 'FCM',
//     //'channel_desc',
//     priority: Priority.high,
//     importance: Importance.max,
//   );
//
//   static var iOS = const DarwinNotificationDetails(presentSound: true);
//
//   Future<void> fcmInit() async {
//     logger.f('INIT NOTIFICATION');
//
//     try {
//       // tz.initializeTimeZones();
//       // if(Platform.isIOS) await FirebaseMessaging.instance.requestPermission();
//       await FirebaseMessaging.instance.requestPermission();
//       FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBg);
//
//       const InitializationSettings settings = InitializationSettings(
//         android: AndroidInitializationSettings('@mipmap/ic_launcher'),
//         iOS: DarwinInitializationSettings(defaultPresentSound: true),
//       );
//
//       await notificationsPlugin.initialize(settings,
//           onDidReceiveNotificationResponse: (payload) async {
//         print('notification 1 ==> onDidReceiveNotificationResponse');
//         final data = json.decode(payload.payload!);
//         logger.i('Notification Payload ==> $data');
//         onMessage(
//           message: RemoteMessage.fromMap({'data': data}),
//         );
//       });
//
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//       await FirebaseMessaging.instance.setAutoInitEnabled(true);
//
//       await FirebaseMessaging.instance
//           .getInitialMessage()
//           .then((RemoteMessage? remoteMessage) async {
//         //this is for outside app notification
//         if (remoteMessage != null) {
//           final String jsonMessage = jsonEncode(remoteMessage.data);
//           print('notification 2 ==> remote message');
//           logger.i('Notification remote message ==> $jsonMessage');
//           // HomeController.hasNotification(true);
//
//           onMessage(message: remoteMessage);
//         }
//       });
//
//       if (Platform.isAndroid) {
//         FirebaseMessaging.onMessage.listen(onForegroundMessage);
//       } else if (Platform.isIOS) {
//         logger.d('version ==> ${await getOSVersion()}');
//         FirebaseMessaging.onMessage.listen(
//           (event) {
//             print('notification 3 ==> event message');
//             logger.d('event on on message==>  $event');
//             // Get.find<NotificationCtrl>()
//             //     .addNotification(notificationData: event);
//             // HomeController.hasNotification(true);
//           },
//         );
//         if (await getOSVersion() < 15.0) {
//           FirebaseMessaging.onMessage.listen(onForegroundMessage);
//         }
//       }
//
//       //IN UI
//
//       FirebaseMessaging.onMessageOpenedApp
//           .listen((RemoteMessage message) async {
//         try {
//           final msg = message.data;
//           print('notification 4 ==> onMessageOpenedApp');
//
//           logger.i('Notification msg ==> $msg');
//           onMessage(message: message);
//         } catch (e) {
//           logger.e(e);
//         }
//       });
//     } catch (e) {
//       logger.e(e);
//     }
//   }
//
//   Future<void> onForegroundMessage(RemoteMessage message) async {
//     try {
//       final msg = message.data;
//       print('notification 5 ==> INCOMING MESSAGE NOTIFICATION');
//       logger.i(
//           'INCOMING MESSAGE NOTIFICATION DATA:${json.encode(message.toMap())}');
//       //
//       // HomeController.hasNotification(true);
//       // Get.find<NotificationCtrl>().addNotification(notificationData: message);
//       if (message.notification != null) {
//         await notificationsPlugin.show(
//           0,
//           message.notification!.title,
//           message.notification!.body,
//           NotificationDetails(android: android, iOS: iOS),
//           payload: json.encode(msg),
//         );
//       }
//     } catch (e) {
//       logger.e(e);
//     }
//   }
//
//   Future<void> onMessage({RemoteMessage? message}) async {
//     try {
//       logger.i('on message');
//
//       final Map<String, dynamic> payload = message!.data;
//       loggerNoStack.w('Payload: $payload');
//       //Received Message
//       // if (payload["ref_id"] != null) {
//       //   var bookId = int.parse(payload["ref_id"]);
//       //   AppFunctions.appRoute(routeName: Routes.storyDetails, bookId: bookId);
//       // }
//     } catch (e) {
//       logger.e('onMessage : $e');
//     }
//   }
//
//   // static Future<void> scheduleNotifications(
//   //     {required DateTime scheduledTime}) async {
//   //   logger.i(scheduledTime, 'scheduledTime');
//   //   try {
//   //     var time = tz.TZDateTime.parse(tz.local, scheduledTime.toString());
//   //     var data = {'msg': 'limit reach', 'id': 0};
//   //     await notificationsPlugin.zonedSchedule(
//   //       0,
//   //       'Time for another Tale!',
//   //       'Open the app and let the storytelling magic continue!',
//   //       time,
//   //       NotificationDetails(android: android, iOS: iOS),
//   //       androidAllowWhileIdle: true,
//   //       payload: json.encode(data),
//   //       // matchDateTimeComponents: DateTimeComponents.dateAndTime,
//   //       // androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//   //       uiLocalNotificationDateInterpretation:
//   //           UILocalNotificationDateInterpretation.absoluteTime,
//   //     );
//   //   } catch (e, t) {
//   //     logger.e('Notification Error :$e \n Trace :$t', '$scheduledTime');
//   //   }
//   // }
//
//   Future<double> getOSVersion() async {
//     final DeviceInfoPlugin info = DeviceInfoPlugin();
//     try {
//       final data = await info.iosInfo;
//       final version = data.systemVersion;
//       final splitStr = version.split('.');
//       final dummy = '${splitStr[0]}.${splitStr[1]}';
//       return double.tryParse(dummy) ?? 0.0;
//     } catch (error) {
//       logger.e('Error in OS Version ${error.toString()}');
//     }
//     return 0.0;
//   }
// }
//
// Future<void> _firebaseMessagingBg(RemoteMessage message) async {
//   logger.i('background open');
//
//   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//     try {
//       // var msg = message.data;
//       try {
//         logger.i('on message');
//
//         final Map<String, dynamic> payload = message.data;
//         loggerNoStack.w('Payload: $payload');
//         //Received Message
//
//         // if (payload["ref_id"] != null) {
//         //   var bookId = int.parse(payload["ref_id"]);
//         //   AppFunctions.appRoute(routeName: Routes.storyDetails, bookId: bookId);
//         // }
//       } catch (e) {
//         logger.e('onMessage : $e');
//       }
//     } catch (e) {
//       logger.e(e);
//     }
//   });
// }
