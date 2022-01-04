import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';

import 'delivery_list.dart';

class Delivery extends StatefulWidget {
  const Delivery({Key? key}) : super(key: key);

  @override
  _DeliveryState createState() => _DeliveryState();
}

class _DeliveryState extends State<Delivery> {
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
              DeliveryList(
                status: 0,
              ),
              DeliveryList(
                status: 1,
              )
            ]),
          )
        ],
      ),
    );
  }
}
