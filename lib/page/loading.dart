import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:driver_app/object/driver.dart';
import 'package:driver_app/share_widget/not_found.dart';
import 'package:driver_app/share_widget/progress_bar.dart';
import 'package:driver_app/translation/app_localizations.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/share_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  /*
  * network checking purpose
  * */
  late StreamSubscription<ConnectivityResult> connectivity;
  bool networkConnection = true;

  final key = GlobalKey<ScaffoldState>();
  late String status;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connectivity = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        networkConnection = (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    connectivity.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if(mounted){
      netWorkChecking();
    }
    return Scaffold(
      backgroundColor: Colors.white,
      key: key,
      body: networkConnection ? const CustomProgressBar() : networkNotFound(),
    );
  }

  Widget networkNotFound() {
    return NotFound(
        title: AppLocalizations.of(context)!.translate('no_network_found'),
        description: AppLocalizations.of(context)!.translate('no_network_found_description'),
        showButton: true,
        refresh: () {
          setState(() {});
        },
        button: AppLocalizations.of(context)!.translate('retry'),
        drawable: 'drawable/no_wifi.png');
  }

  netWorkChecking() async {
    var result = await (Connectivity().checkConnectivity());
    if (result == ConnectivityResult.mobile || result == ConnectivityResult.wifi) {
      checkDriverInformation();
    } else {
      setState(() {
        networkConnection = false;
      });
    }
  }

  void checkDriverInformation() async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      var data = await SharePreferences().read('driver');
      if (data != null) {
        //Navigator.pushReplacementNamed(context, '/login');
        launchChecking();
      } else {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } on Exception {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void launchChecking() async {
    Map data = await Domain().launchCheck();
    if (data['status'] == '1') {
      status = data['driver'][0]['status'].toString();
      //store google api key
      await SharePreferences().save('google_api_key', data['google_api'][0]['api_key']);
      //get current version
      String latestVersion = data['version'][0]['version'].toString();
      String currentVersion = await getVersionNumber();
      if (latestVersion != currentVersion) {
        openUpdateDialog(data);
        return;
      }
      checkDriverStatus();
    } else {
      openDisableDialog();
    }
  }

  checkDriverStatus() async {
    if (mounted) {
      String driverStatus = status;
      if (driverStatus == '0') {
        Driver driver = Driver.fromJson(await SharePreferences().read('driver'));
        driver.driverId != null ? Navigator.pushReplacementNamed(context, '/home') : Navigator.pushReplacementNamed(context, '/login');
        return;
      }
      openDisableDialog();
    }
  }

  getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  /*
  * edit product dialog
  * */
  openDisableDialog() {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.translate('wait_for_approval'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.translate('wait_for_approval_description'),
                  style: const TextStyle(fontSize: 14),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
                SystemChannels.platform.invokeMethod('SystemNavigator.pop');
              },
            )
          ],
        );
      },
    );
  }

/*
  * update available
  * */
  openUpdateDialog(data) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return alert dialog object
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            AppLocalizations.of(context)!.translate('new_version'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 50,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppLocalizations.of(context)!.translate('new_version_description'),
                  style: const TextStyle(fontSize: 15),
                  textAlign: TextAlign.left,
                )
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(AppLocalizations.of(context)!.translate('later')),
              onPressed: () {
                Navigator.of(context).pop();
                checkDriverStatus();
              },
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.translate('update_now'),
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                launch((Platform.isIOS ? data['version'][0]['appstore_url'].toString() : data['version'][0]['playstore_url'].toString()));
              },
            ),
          ],
        );
      },
    );
  }
}
