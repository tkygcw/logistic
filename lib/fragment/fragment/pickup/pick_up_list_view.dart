import 'dart:async';

import 'package:driver_app/object/parcel.dart';
import 'package:driver_app/object/task.dart';
import 'package:driver_app/share_widget/progress_bar.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';

import 'package:url_launcher/url_launcher.dart';

class PickUpListView extends StatefulWidget {
  final Task task;
  final Function() onClick;

  const PickUpListView({Key? key, required this.task, required this.onClick}) : super(key: key);

  @override
  _PickUpListViewState createState() => _PickUpListViewState();
}

class _PickUpListViewState extends State<PickUpListView> {
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
                  setState(() {
                    openChild = !openChild;
                    if (openChild) {
                      getPickUpParcel();
                    }
                  });
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
                    Text(
                      '${widget.task.merchant!.company}',
                      maxLines: 1,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${widget.task.merchant!.address}',
                      style: const TextStyle(fontSize: 12),
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
            if (openChild) list.isNotEmpty ? childLayout() : const CustomProgressBar()
          ],
        ));
  }

  Widget childLayout() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.fromLTRB(20, 0, 20, 0), child: Divider(color: Colors.blueGrey)),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      scannedParcel.toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.teal),
                    ),
                    Text(
                      Utils.getText(context, 'scanned_parcel'),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      list.length.toString(),
                      style: const TextStyle(fontSize: 20, color: Colors.teal),
                    ),
                    Text(
                      Utils.getText(context, 'total_parcel'),
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: widget.task.status == 0,
                child: Expanded(
                  child: IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.black54,),
                    onPressed: () => getPickUpParcel(),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          if (widget.task.status == 0)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: widget.task.status == 0 && isAllParcelFinishScan() ? () => openUpdateDialog() : null,
                child: Text(
                  Utils.getText(context, 'complete_task'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(width: 1.0, color: Colors.teal),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget popUpMenu() {
    return PopupMenuButton(
      icon: const Icon(Icons.tune),
      offset: const Offset(0, 10),
      itemBuilder: (context) => [
        _buildMenuItem('map', 'open_map'),
        _buildMenuItem('call', 'call'),
      ],
      onCanceled: () {},
      onSelected: (value) {
        switch (value) {
          case 'map':
            openMapsSheet();
            break;
          case 'call':
            phoneCall();
            break;
        }
      },
    );
  }

  phoneCall() async {
    var url = 'tel://+${Utils.getPhoneNumber(widget.task.merchant!.phone)}';
    if (!await canLaunch(url)) {
      showSnackBar('invalid_path');
      return;
    }
    launch(url);
  }

  openMapsSheet() async {
    try {
      var coordinate = await getCoordinate();
      if (coordinate == null) {
        showSnackBar('invalid_address');
        return;
      }
      final availableMaps = await MapLauncher.installedMaps;
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Wrap(
                children: <Widget>[
                  for (var map in availableMaps)
                    ListTile(
                      onTap: () => map.showMarker(
                        coords: Coords(coordinate.latitude, coordinate.longitude),
                        title: widget.task.merchant!.company.toString(),
                        description: widget.task.merchant!.address,
                      ),
                      title: Text(map.mapName),
                      leading: const Image(
                        image: AssetImage('drawable/placeholder.png'),
                        height: 30.0,
                        width: 30.0,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      );
    } catch (e) {
      showSnackBar('invalid_address');
    }
  }

  /*
  * update available
  * */
  openUpdateDialog() {
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
            height: 90,
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
                updateTaskStatus();
              },
            ),
          ],
        );
      },
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
    scannedParcel = 0;
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

  updateTaskStatus() async {
    Map data = await Domain().updatePickUpTaskStatus(widget.task.taskId);
    if (data['status'] == '1') {
      showSnackBar('update_success');
      Navigator.of(context).pop();
    }
    setState(() {
      widget.task.status = 1;
    });
  }

  isAllParcelFinishScan() {
    if (list.length == scannedParcel) return true;
    return false;
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
