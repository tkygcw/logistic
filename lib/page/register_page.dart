import 'package:driver_app/object/driver.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _platformVersion = 'Default';

  //controller
  var plateNo = TextEditingController();
  var postcode = TextEditingController();
  var address = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var name = TextEditingController();
  var ic = TextEditingController();
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
      body: Builder(builder: (BuildContext innerContext) {
        return SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    Utils.getText(context, 'driver_register'),
                    style: GoogleFonts.alata(
                      textStyle: const TextStyle(fontSize: 25, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: name,
                    autocorrect: false,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: Utils.getText(context, 'name'),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: email,
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: Utils.getText(context, 'email'),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.email),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: password,
                    obscureText: hidePassword,
                    autocorrect: false,
                    decoration: InputDecoration(
                      hintText: Utils.getText(context, 'password'),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(icon: const Icon(Icons.remove_red_eye), onPressed: () => showPassword()),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: phone,
                    autocorrect: false,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: Utils.getText(context, 'phone'),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.phone_android),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: address,
                    autocorrect: false,
                    minLines: 1,
                    maxLines: 5,
                    textAlignVertical: TextAlignVertical.center,
                    textCapitalization: TextCapitalization.characters,
                    keyboardType: TextInputType.streetAddress,
                    decoration: InputDecoration(
                      hintText: Utils.getText(context, 'address'),
                      alignLabelWithHint: true,
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.house),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: postcode,
                          autocorrect: false,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          textAlignVertical: TextAlignVertical.center,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: Utils.getText(context, 'postcode'),
                            alignLabelWithHint: true,
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.location_on),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: TextField(
                          controller: plateNo,
                          textCapitalization: TextCapitalization.characters,
                          textAlignVertical: TextAlignVertical.center,
                          autocorrect: false,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            hintText: Utils.getText(context, 'plate_no'),
                            alignLabelWithHint: true,
                            border: InputBorder.none,
                            prefixIcon: const Icon(Icons.car_rental),
                          ),
                        ),
                      ),
                    ],
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
                        Utils.getText(context, 'sign_up'),
                        style: const TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        register();
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
                            text: Utils.getText(context, 'have_account'),
                            style: const TextStyle(color: Colors.blueGrey),
                            children: <TextSpan>[
                              TextSpan(
                                  text: Utils.getText(context, 'sign_in_now'),
                                  style: const TextStyle(color: Colors.black87, decoration: TextDecoration.underline),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
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
                  )
                ],
              ),
            ),
          ),
        );
      }),
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

  void register() async {
    if (name.text.isNotEmpty &&
        email.text.isNotEmpty &&
        password.text.isNotEmpty &&
        phone.text.isNotEmpty &&
        address.text.isNotEmpty &&
        postcode.text.isNotEmpty) {
      Map data = await Domain().register(
          Driver(name: name.text, email: email.text, phone: phone.text, address: address.text, postcode: postcode.text, plateNo: plateNo.text),
          password.text);

      if (data['status'] == '1') {
        showSnackBar(context, Utils.getText(context, 'sign_up_success'));
        await Future.delayed(const Duration(milliseconds: 500));
        Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
      } else if (data['status'] == 'user_existed') {
        showSnackBar(context, Utils.getText(context, 'user_existed'));
      }
    } else {
      showSnackBar(context, Utils.getText(context, 'all_field_required'));
    }
  }

  void showSnackBar(context, text) {
    final snackBar = SnackBar(content: Text(text));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
