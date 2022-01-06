import 'dart:async';

import 'package:driver_app/object/parcel.dart';
import 'package:driver_app/object/task.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'order/delivery_reference.dart';

class DeliveryListView extends StatefulWidget {
  final Task task;
  final Function() onClick;

  const DeliveryListView({Key? key, required this.task, required this.onClick}) : super(key: key);

  @override
  _DeliveryListViewState createState() => _DeliveryListViewState();
}

class _DeliveryListViewState extends State<DeliveryListView> {
  bool openChild = false;
  late List<Parcel> list = [];
  int scannedParcel = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
                onTap: () async {
                  openDeliveryTaskOrder();
                },
                contentPadding: const EdgeInsets.all(10),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Utils.idPrefix(widget.task.taskId.toString()),
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${widget.task.numOrder} ${Utils.getText(context, 'task')}',
                      maxLines: 1,
                      style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      Task.formatDate(widget.task.createdAt),
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12, color: Colors.black87),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: widget.task.status == 0 ? Colors.blueGrey : Colors.green,
                      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: Text(
                        '${Utils.getText(context, widget.task.status == 0 ? 'pending' : 'complete')}',
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                leading: const Icon(
                  Icons.arrow_drop_down,
                  color: Colors.teal,
                  size: 30,
                ),
                trailing: popUpMenu()),
          ],
        ));
  }

  Widget popUpMenu() {
    return PopupMenuButton(
      icon: const Icon(Icons.tune),
      offset: const Offset(0, 10),
      itemBuilder: (context) => [
        _buildMenuItem('detail', 'view_detail'),
        _buildMenuItem('complete', 'complete_task'),
      ],
      onCanceled: () {},
      onSelected: (value) {
        switch (value) {
          case 'detail':
            openDeliveryTaskOrder();
            break;
          case 'complete':
            openTaskCompleteDialog();
            break;
        }
      },
    );
  }

  /*
  * task complete dialog
  * */
  openTaskCompleteDialog() {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            Utils.getText(context, 'update_request'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 60,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: Utils.getText(context, 'task_complete_description'), style: const TextStyle(color: Colors.black, fontSize: 15)),
                  const TextSpan(text: '\n'),
                  TextSpan(
                      text: Utils.getText(context, 'task_complete_description_2'),
                      style: const TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold)),
                ])),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(Utils.getText(context, 'cancel')),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                Utils.getText(context, 'sure'),
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                updatePickUpTaskStatus();
              },
            ),
          ],
        );
      },
    );
  }

  openDeliveryTaskOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryOrder(taskId: widget.task.taskId),
      ),
    );
  }

  Future<Location?> getCoordinate() async {
    final address = widget.task.merchant!.address;
    if (address != null) {
      List<Location> locations = await locationFromAddress(address);
      return locations[0];
    }
    return null;
  }

  getPickUpParcel() async {
    list.clear();
    Map data = await Domain().pickUpParcel(widget.task.taskId);
    if (data['status'] == '1') {
      List responseJson = data['parcel'];
      list.addAll(responseJson.map((jsonObject) => Parcel.fromJson(jsonObject)).toList());
      //check scanned parcel
      for (int i = 0; i < list.length; i++) {
        if (list[i].status != 0) scannedParcel++;
      }
    }
    setState(() {});
  }

  updatePickUpTaskStatus() async {
    Map data = await Domain().updateDeliveryOrderStatus(widget.task.taskId);
    Navigator.of(context).pop();
    if (data['status'] == '1') {
      showSnackBar('update_success');
    } else if (data['status'] == '3') {
      showSnackBar('incompleted_job');
      return;
    }
    setState(() {
      widget.task.status = 1;
    });
  }

  PopupMenuItem _buildMenuItem(String value, String text) {
    return PopupMenuItem(
      value: value,
      child: Text(Utils.getText(context, text)),
    );
  }

  showSnackBar(label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(Utils.getText(context, label)),
    ));
  }
}
