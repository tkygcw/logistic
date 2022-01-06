import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  //NotificationService a singleton object
  static final NotificationService _notificationService = NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';

  // ignore: prefer_typing_uninitialized_variables
  var _androidNotificationDetails;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('logo');

    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: (message) => selectNotification(message));
    createChannel();
  }

  createChannel() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var notificationChannel = const AndroidNotificationChannel(
      'order_notification',
      'Order Notification',
      playSound: true,
      importance: Importance.high,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(notificationChannel);
  }

  Future<void> showNotifications(message) async {
    _androidNotificationDetails = const AndroidNotificationDetails(
      'order_notification',
      'Order Notification',
      channelDescription: "CHANNEL_DESCRIPTION",
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      icon: 'logo',
      styleInformation: DefaultStyleInformation(true, true),
    );

    var platformChannelSpecifics = NotificationDetails(android: _androidNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      platformChannelSpecifics,
      payload: message.data['id'],
    );
  }

  Future<void> scheduleNotifications() async {
//    await flutterLocalNotificationsPlugin.zonedSchedule(0, "Notification Title", "This is the Notification Body!",
//        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)), NotificationDetails(android: _androidNotificationDetails),
//        androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future<void> selectNotification(String? payload) async {
  print('haha: $payload');
  //handle your logic here
}
