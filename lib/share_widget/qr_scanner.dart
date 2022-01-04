import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  final int action;
  final String? referenceId;
  final String? taskId;

  const QrScanner({Key? key, required this.action, this.referenceId, this.taskId}) : super(key: key);

  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  late AudioCache _audioCache;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _audioCache = AudioCache(prefix: "audio/", fixedPlayer: AudioPlayer()..setReleaseMode(ReleaseMode.STOP));
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Stack(
        children: [
          qrCodeLayout(),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
              child: ElevatedButton.icon(
                  icon: const Icon(
                    Icons.flash_on,
                    color: Colors.white,
                    size: 30.0,
                  ),
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(180, 70),
                    primary: Colors.teal,
                  ),
                  label: FutureBuilder(
                    future: controller?.getFlashStatus(),
                    builder: (context, snapshot) {
                      return Text(
                        '${Utils.getText(context, 'flash_light')}: ${snapshot.data.toString() == 'true' ? 'On' : 'Off'}',
                        style: const TextStyle(fontSize: 15),
                      );
                    },
                  )),
            ),
          ),
        ],
      ),
    ));
  }

  Widget qrCodeLayout() {
    var scanArea = (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(borderColor: Colors.red, borderRadius: 10, borderLength: 30, borderWidth: 10, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        FlutterBeep.beep();
        result = scanData;
        controller.pauseCamera();
        updateParcel(scanData.code);
      });
    });
  }

  scanSound({required bool success}) {
    _audioCache.play(success ? 'beep.mp3' : 'error.mp3');
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  updateParcel(parcelId) async {
    Map data = await Domain().scanParcel(getAction(), parcelId, widget.action, referenceId: widget.referenceId ?? '', taskId: widget.taskId ?? '');
    if (data['status'] != '1') {
      scanSound(success: false);
      openResultDialog(data);
    }
    else {
      scanSound(success: true);
      controller!.resumeCamera();
    }
  }

  getAction() {
    switch (widget.action) {
      case 1:
        return 'pick_up';
      case 3:
        return 'out_of_delivery';
      case 4:
        return 'delivery';
    }
  }

  /*
  * update available
  * */
  openResultDialog(message) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            Utils.getText(context, message['status'] != '1' ? 'fail_scan' : 'scan_success'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: 120,
            child: Column(children: [
              Icon(
                message['status'] != '1' ? Icons.error : Icons.check_circle,
                color: message['status'] != '1' ? Colors.redAccent : Colors.green,
                size: 80,
              ),
              Text(
                Utils.getText(context, message['message']),
                style: const TextStyle(fontSize: 15),
              )
            ]),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                Utils.getText(context, 'got_it'),
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                controller!.resumeCamera();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
