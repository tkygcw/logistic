import 'package:driver_app/fragment/fragment/delivery/order/proof_of_delivery.dart';
import 'package:driver_app/object/order.dart';
import 'package:driver_app/object/parcel.dart';
import 'package:driver_app/share_widget/parcel_shipping_status.dart';
import 'package:driver_app/share_widget/progress_bar.dart';
import 'package:driver_app/share_widget/qr_scanner.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class DeliveryOrderDetail extends StatefulWidget {
  final String orderId;

  const DeliveryOrderDetail({Key? key, required this.orderId}) : super(key: key);

  @override
  _DeliveryOrderDetailState createState() => _DeliveryOrderDetailState();
}

class _DeliveryOrderDetailState extends State<DeliveryOrderDetail> {
  bool isLoad = false;
  late DeliveryReference order;
  List<Parcel> parcels = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDeliveryOrderDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${Utils.getText(context, 'reference')} ${Utils.idPrefix(widget.orderId)}',
            style: GoogleFonts.acme(
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.teal),
            ),
          ),
          actions: [IconButton(onPressed: () => openQrScanner(), icon: const Icon(Icons.qr_code_scanner))],
        ),
        bottomNavigationBar: BottomAppBar(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: isLoad && order.status != 1 && isAllParcelSend()
                ? () async {
                    setState(() {
                      openUpdateOrderDialog();
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              primary: Colors.teal,
            ),
            child: Text(Utils.getText(context, 'task_complete')),
          ),
        )),
        body: isLoad
            ? SingleChildScrollView(
                child: Column(
                  children: [recipientInfo(), parcelLayout()],
                ),
              )
            : const CustomProgressBar());
  }

  Widget recipientInfo() {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(8),
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Utils.getText(context, 'delivery_info'),
                    style: const TextStyle(fontSize: 15),
                  ),
                  Container(
                    color: order.status == 0 ? Colors.blueGrey : Colors.green,
                    padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                    child: Text(
                      '${Utils.getText(context, order.status == 0 ? 'pending' : 'complete')}',
                      style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_pin,
                            color: Colors.black54,
                            size: 35,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            '${order.name}',
                            maxLines: 1,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${Utils.getText(context, 'phone')}',
                        style: const TextStyle(fontSize: 12, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${order.phone}',
                        maxLines: 1,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${Utils.getText(context, 'address')}',
                        style: const TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${order.address}',
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${Utils.getText(context, 'postcode')}',
                        style: const TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${order.postcode}',
                        style: const TextStyle(fontSize: 15, color: Colors.black87),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${Utils.getText(context, 'bid_no')}',
                        style: const TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${order.remark == '' ? '-' : order.bidNo}',
                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        '${Utils.getText(context, 'remark')}',
                        style: const TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${order.remark == '' ? '-' : order.remark}',
                        style: const TextStyle(fontSize: 13, color: Colors.black87),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
                Expanded(child: popUpMenu())
              ]),
              Text(
                '${Utils.getText(context, 'proof_of_delivery')}',
                style: const TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.bold),
              ),
              ProofOfDelivery(
                refresh: () {
                  print('refresh');
                  getDeliveryOrderDetail();
                },
                deliveryReference: order,
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          )),
    );
  }

  Widget parcelLayout() {
    return Card(
        elevation: 5,
        margin: const EdgeInsets.all(8),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  const Icon(
                    Icons.local_shipping,
                    color: Colors.teal,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    Utils.getText(context, 'parcel_info'),
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [for (int i = 0; i < parcels.length; i++) parcelListView(parcels[i])],
              )
            ])));
  }

  Widget parcelListView(Parcel parcel) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: InkWell(
                      onTap: () => openParcelDialog(parcel),
                      child: Text(
                        Utils.idPrefix(parcel.barcode.toString()),
                        style: const TextStyle(fontSize: 12, color: Colors.blue, decoration: TextDecoration.underline),
                      ),
                    )),
                Expanded(
                    flex: 2,
                    child: Text(
                      parcel.name.toString(),
                      style: const TextStyle(fontSize: 14),
                    )),
                Expanded(
                  flex: 2,
                  child: Text(
                    Utils.getText(context, Parcel.getStatus(parcel.status)),
                    textAlign: TextAlign.start,
                    style: const TextStyle(fontSize: 13, color: Colors.blueGrey, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Divider(color: Colors.grey),
            )
          ],
        ));
  }

  openQrScanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QrScanner(action: 4, referenceId: widget.orderId),
      ),
    );
  }

  /*
  * update phone number
  * */
  openParcelDialog(Parcel parcel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return ParcelShippingStatus(
          parcel: parcel,
        );
      },
    );
  }

  Widget popUpMenu() {
    return PopupMenuButton(
      icon: const Icon(
        Icons.settings,
        size: 25,
        color: Colors.teal,
      ),
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

  PopupMenuItem _buildMenuItem(String value, String text) {
    return PopupMenuItem(
      value: value,
      child: Text(Utils.getText(context, text)),
    );
  }

  Future<Location?> getCoordinate() async {
    final address = order.address;
    if (address != null) {
      List<Location> locations = await locationFromAddress(address);
      return locations[0];
    }
    return null;
  }

  phoneCall() async {
    var url = 'tel://+${Utils.getPhoneNumber(order.phone)}';
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
                        title: order.name.toString(),
                        description: order.address,
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

  /*
  * update available
  * */
  openUpdateOrderDialog() {
    bool allParcelSend = isAllParcelSend();
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          contentPadding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          backgroundColor: Colors.white,
          title: Text(
            Utils.getText(context, 'update_request'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: allParcelSend ? 60 : 160,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (!allParcelSend)
                  const Icon(
                    Icons.error,
                    color: Colors.redAccent,
                    size: 80,
                  ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: Utils.getText(context, !allParcelSend ? 'some_parcel_not_delivery' : 'task_complete_description'),
                      style: const TextStyle(color: Colors.black, fontSize: 15)),
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
                updateOrderStatus();
              },
            ),
          ],
        );
      },
    );
  }

  isAllParcelSend() {
    for (int i = 0; i < parcels.length; i++) {
      if (parcels[i].status != 4) return false;
    }
    return true;
  }

  updateOrderStatus() async {
    Map data = await Domain().updateReferenceStatus(widget.orderId, '1');
    if (data['status'] == '1') {
      showSnackBar('update_success');
      Navigator.of(context).pop();
    }
    setState(() {
      order.status = 1;
    });
  }

  getDeliveryOrderDetail() async {
    try {
      Map data = await Domain().orderDetail(widget.orderId);
      print(data);
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        if (data['status'] == '1') {
          List references = data['references'];
          order = DeliveryReference.fromJson(references[0]);

          List parcel = data['parcel'];
          parcels.clear();
          parcels.addAll(parcel.map((jsonObject) => Parcel.fromJson(jsonObject)).toList());
          isLoad = true;
        } else {
          Navigator.of(context).pop();
        }
      });
      // ignore: empty_catches
    } catch ($e) {
      Navigator.of(context).pop();
    }
  }

  showSnackBar(label) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(Utils.getText(context, label)),
    ));
  }
}
