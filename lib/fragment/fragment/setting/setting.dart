import 'package:driver_app/fragment/fragment/setting/profile.dart';
import 'package:driver_app/fragment/fragment/setting/reset_password.dart';
import 'package:driver_app/page/loading.dart';
import 'package:driver_app/share_widget/language_setting.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/share_preference.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  String _platformVersion = 'Default';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getVersionNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                child: Text(
                  Utils.getText(context, 'account'),
                  style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
                ),
              ),
              ListTile(
                onTap: () => openProfilePage(),
                leading: const Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.blue,
                ),
                title: Text(Utils.getText(context, 'edit_profile')),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.blueGrey,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 10, 0),
                child: Divider(
                  height: 1,
                  color: Colors.black38,
                ),
              ),
              ListTile(
                onTap: () => openChangePasswordPage(),
                leading: const Icon(
                  Icons.vpn_key,
                  size: 30,
                  color: Colors.amber,
                ),
                title: Text(Utils.getText(context, 'change_password')),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.blueGrey,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 10, 0),
                child: Divider(
                  height: 1,
                  color: Colors.black38,
                ),
              ),
              ListTile(
                onTap: () => showLanguageDialog(),
                leading: const Icon(
                  Icons.translate,
                  size: 30,
                  color: Colors.redAccent,
                ),
                title: Text(Utils.getText(context, 'language')),
                trailing: const Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.blueGrey,
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(50, 0, 10, 0),
                child: Divider(
                  height: 1,
                  color: Colors.black38,
                ),
              ),
              aboutAppLayout(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(child: footerLayout()),
    );
  }

  Widget aboutAppLayout() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          Text(
            '${Utils.getText(context, 'about_the_app')}',
            style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
              onTap: () => launch(('https://www.channelsoft.com.my')),
              title: const Text(
                'CHANNEL SOFT PLT',
                style: TextStyle(color: Color.fromRGBO(89, 100, 109, 1)),
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
            child: Divider(
              color: Colors.teal.shade100,
              thickness: 1.0,
            ),
          ),
          ListTile(
              onTap: () => launch(('https://www.channelsoft.com.my/contact-us/')),
              title: Text(
                '${Utils.getText(context, 'contact_us')}',
                style: const TextStyle(color: Color.fromRGBO(89, 100, 109, 1)),
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
            child: Divider(
              color: Colors.teal.shade100,
              thickness: 1.0,
            ),
          ),
          ListTile(
              onTap: () => launch(('https://www.channelsoft.com.my/privacy-policy/')),
              title: Text(
                '${Utils.getText(context, 'privacy_policy')}',
                style: const TextStyle(color: Color.fromRGBO(89, 100, 109, 1)),
              ),
              trailing: const Icon(
                Icons.keyboard_arrow_right,
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(40, 0, 0, 0),
            child: Divider(
              color: Colors.teal.shade100,
              thickness: 1.0,
            ),
          ),
          const SizedBox(
            height: 35,
          ),
        ],
      ),
    );
  }

  Widget footerLayout() {
    return SizedBox(
      height: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(
            height: 50,
          ),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 50.0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
                child: OutlinedButton(
                  onPressed: () => showLogOutDialog(),
                  child: Text(
                    Utils.getText(context, 'log_out'),
                    style: const TextStyle(fontSize: 15, color: Colors.red),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(width: 1.0, color: Colors.redAccent),
                  ),
                ),
              ),
            ),
          ),
          Text(
            '${Utils.getText(context, 'all_right_reserved_by')} AVIS VISION',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            _platformVersion,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          )
        ],
      ),
    );
  }

  getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    setState(() {
      _platformVersion = version;
    });
  }

  openProfilePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Profile(),
      ),
    );
  }

  openChangePasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ResetPassword(),
      ),
    );
  }

  Future<Future<Object?>> showLanguageDialog() async {
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(opacity: a1.value, child: const LanguageDialog()),
          );
        },
        transitionDuration: const Duration(milliseconds: 200),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          return const Text('');
        });
  }

  Future<void> showLogOutDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${Utils.getText(context, 'sign_out_request')}'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('${Utils.getText(context, 'sign_out_message')}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('${Utils.getText(context, 'cancel')}'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                '${Utils.getText(context, 'confirm')}',
                style: const TextStyle(color: Colors.red),
              ),
              onPressed: () {
                logOut();
              },
            ),
          ],
        );
      },
    );
  }

  logOut() async {
    String token = await SharePreferences().read('token');
    Map data = await Domain().updateTokenStatus(token.toString());
    print(data);
    if (data['status'] == '1') {
      SharePreferences().clear();
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext context) => const LoadingPage()), ModalRoute.withName('/'));
    } else {
      Utils.showSnackBar(context, 'something_went_wrong');
    }
  }
}
