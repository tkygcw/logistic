import 'package:driver_app/fragment/fragment/pickup/pick_up_list.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';

class PickUp extends StatefulWidget {
  const PickUp({Key? key}) : super(key: key);

  @override
  _PickUpState createState() => _PickUpState();
}

class _PickUpState extends State<PickUp> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            constraints: const BoxConstraints.expand(height: 50),
            child: TabBar(
                indicatorColor: Colors.teal,
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.grey,
                labelStyle: const TextStyle(fontSize: 15),
                tabs: [
                  Tab(text: '${Utils.getText(context, 'processing')}'),
                  Tab(text: '${Utils.getText(context, 'completed')}'),
                ]),
          ),
          const Expanded(
            child: TabBarView(children: [
              PickUpPage(
                status: 0,
              ),
              PickUpPage(
                status: 1,
              )
            ]),
          )
        ],
      ),
    );
  }
}
