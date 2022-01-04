import 'package:driver_app/fragment/fragment/delivery/delivery.dart';
import 'package:driver_app/fragment/fragment/pickup/pick_up.dart';
import 'package:driver_app/fragment/fragment/setting/setting.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
}
