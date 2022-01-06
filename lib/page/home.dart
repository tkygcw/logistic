import 'package:driver_app/fragment/fragment/delivery/delivery.dart';
import 'package:driver_app/fragment/fragment/pickup/pick_up.dart';
import 'package:driver_app/fragment/fragment/setting/setting.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/notification_service.dart';
import 'package:driver_app/utils/share_preference.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io' show Platform;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static const List<Widget> pages = <Widget>[PickUp(), Delivery(), SettingPage()];

  final List<String> title = <String>['pick_up', 'delivery', 'option'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      setupNotification();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          Utils.getText(context, title[_selectedIndex]),
          style: GoogleFonts.acme(
            textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400, color: Colors.teal),
          ),
        ),
      ),
      body: Center(
        child: pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.move_to_inbox),
            label: Utils.getText(context, 'pick_up'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.local_shipping),
            label: Utils.getText(context, 'delivery'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: Utils.getText(context, 'option'),
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> setupNotification() async {
    NotificationService _notificationService = NotificationService();
    /*
    * firebase messaging
    * */
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      _notificationService.showNotifications(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      clickAction(message);
    });

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {}
    });
    /*
    * register token
    * */
    _firebaseMessaging.getToken().then((token) async {
      await SharePreferences().save('token', token);
      await Domain().registerDeviceToken(token);
    });
  }

  void clickAction(message) async {
    if (mounted) {
      setState(() {
        try {
          if (message.data['type'] == 'pick_up') {
            _selectedIndex = 0;
          } else {
            _selectedIndex = 1;
          }
        } catch ($e) {
          _selectedIndex = 0;
        }
      });
    }
  }
}
