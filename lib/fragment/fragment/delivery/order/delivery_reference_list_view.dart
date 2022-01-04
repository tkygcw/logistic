import 'package:driver_app/object/order.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

import 'delivery_reference_detail.dart';

class DeliveryOrderListView extends StatefulWidget {
  final DeliveryReference order;
  final Function() onClick;

  const DeliveryOrderListView({Key? key, required this.order, required this.onClick}) : super(key: key);

  @override
  _DeliveryOrderListViewState createState() => _DeliveryOrderListViewState();
}

class _DeliveryOrderListViewState extends State<DeliveryOrderListView> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 5,
        margin: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
                onTap: () => openDeliveryOrderDetail(),
                contentPadding: const EdgeInsets.all(10),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DeliveryReference.orderIdPrefix(widget.order.deliveryReferenceId.toString()),
                      maxLines: 1,
                      style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
                    ),
                    Text(
                      '${widget.order.name}',
                      maxLines: 1,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${widget.order.address}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      color: widget.order.status == 0 ? Colors.blueGrey : Colors.green,
                      padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                      child: Text(
                        '${Utils.getText(context, widget.order.status == 0 ? 'pending' : 'complete')}',
                        style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                leading: const Icon(
                  Icons.person,
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
          case 'detail':
            openDeliveryOrderDetail();
            break;
        }
      },
    );
  }

  phoneCall() async {
    var url = 'tel://+${Utils.getPhoneNumber(widget.order.phone)}';
    if (!await canLaunch(url)) {
      Utils.showSnackBar(context, 'invalid_path');
      return;
    }
    launch(url);
  }

  openMapsSheet() async {
    try {
      var coordinate = await getCoordinate();
      if (coordinate == null) {
        Utils.showSnackBar(context, 'invalid_address');
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
                        title: widget.order.name.toString(),
                        description: widget.order.address,
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
      Utils.showSnackBar(context, 'invalid_address');
    }
  }

  openDeliveryOrderDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryOrderDetail(orderId: widget.order.deliveryReferenceId.toString()),
      ),
    );
  }

  Future<Location?> getCoordinate() async {
    final address = widget.order.address;
    if (address != null) {
      List<Location> locations = await locationFromAddress(address);
      return locations[0];
    }
    return null;
  }

  PopupMenuItem _buildMenuItem(String value, String text) {
    return PopupMenuItem(
      value: value,
      child: Text(Utils.getText(context, text)),
    );
  }
}
