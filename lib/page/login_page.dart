import 'package:driver_app/object/driver.dart';
import 'package:driver_app/page/register_page.dart';
import 'package:driver_app/translation/app_localizations.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/share_preference.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';

import 'forgot_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginPage> {
  String _platformVersion = 'Default';

  //clear message purpose
  var email = TextEditingController();
  var password = TextEditingController();
  bool hidePassword = true;

  @override
  initState() {
    super.initState();
    getVersionNumber();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Image.asset('drawable/logo.png', height: 100),
                ),
                const SizedBox(height: 10.0),
                Text(
                  Utils.getText(context, 'driver_login'),
                  style: GoogleFonts.alata(
                    textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                  ),
                ),
                const SizedBox(height: 50.0),
                customTextField(email, 'email', null),
                const SizedBox(height: 20.0),
                customTextField(password, 'password', hidePassword),
                const SizedBox(height: 5.0),
                GestureDetector(
                  onTap: () {
                    forgotPasswordPage();
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      Utils.getText(context, 'forgot_password'),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      primary: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    child: Text(
                      Utils.getText(context, 'sign_in'),
                      style: const TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      login();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          text: Utils.getText(context, 'no_account'),
                          style: const TextStyle(color: Colors.blueGrey),
                          children: <TextSpan>[
                            TextSpan(
                                text: Utils.getText(context, 'sign_up_now'),
                                style: const TextStyle(color: Colors.black87, decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()..onTap = () => Navigator.pushNamed(context, '/register')),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '${Utils.getText(context, 'all_right_reserved_by')} Avis Vision Solution Sdn Bhd',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
              Text(
                '${Utils.getText(context, 'version')} $_platformVersion',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ),
        elevation: 0,
      ),
    );
  }

  forgotPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ForgotPassword(),
      ),
    );
  }

  // Toggles the password show status
  void showPassword() {
    setState(() {
      hidePassword = !hidePassword;
    });
  }

  void getVersionNumber() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    setState(() {
      _platformVersion = version;
    });
  }

  void login() async {
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
      Map data = await Domain().login(email.text, password.text);
      if (data['status'] == '1') {
        //user information
        print(data['driver_info']);
        storeUser(data['driver_info']);
        showSnackBar(context, Utils.getText(context, 'login_success'));
      } else {
        showSnackBar(context, Utils.getText(context, 'invalid_email_password'));
      }
    } else {
      showSnackBar(context, Utils.getText(context, 'all_field_required'));
    }
  }

  storeUser(data) async {
    try {
      await SharePreferences().save('driver', Driver(driverId: data['driver_id'].toString(), name: data['name'], email: data['email']));
      Navigator.pushReplacementNamed(context, '/');
      // ignore: empty_catches
    } on Exception {}
  }

  void showSnackBar(context, text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  TextField customTextField(controller, String hint, hidePassword) {
    return TextField(
      controller: controller,
      obscureText: hint == 'password' ? hidePassword : false,
      autocorrect: false,
      decoration: InputDecoration(
        hintText: '${AppLocalizations.of(context)?.translate(hint)}',
        border: InputBorder.none,
        suffixIcon: IconButton(
            icon: hint == 'password' ? const Icon(Icons.remove_red_eye) : const Icon(Icons.clear),
            onPressed: () => hint == 'password' ? showPassword() : controller.clear()),
        prefixIcon: Icon(hint == 'password' ? Icons.lock : Icons.email),
      ),
    );
  }
}
