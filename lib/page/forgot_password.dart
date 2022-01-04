import 'dart:async';
import 'dart:math';

import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var email = TextEditingController();
  var pac = TextEditingController();

  var newPassword = TextEditingController();
  var confirmPassword = TextEditingController();

  bool hideNewPassword = true;
  bool hideConfirmPassword = true;

  StreamController pageStream = StreamController();
  late String pacNumber;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pageStream.add('');
    pageStream.add('email');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: StreamBuilder(
                stream: pageStream.stream,
                builder: (context, object) {
                  if (object.data == 'email') {
                    return enterEmail();
                  } else if (object.data == 'pac') {
                    return verifyPac();
                  } else {
                    return resetPassword();
                  }
                })),
      ),
    );
  }

  enterEmail() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      IconButton(
        icon: const Icon(
          Icons.close,
          color: Colors.grey,
        ),
        onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
      ),
      Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset('drawable/forgot_password_icon.png', height: 200),
              ),
              Text(
                '${Utils.getText(context, 'forgot_password')}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                '${Utils.getText(context, 'forgot_password_description')}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: email,
                textAlign: TextAlign.start,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  labelText: '${Utils.getText(context, 'email')}',
                  labelStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                  hintText: '',
                  border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                ),
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 5,
                    primary: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                  onPressed: () => sendPac(context),
                  child: Text(
                    '${Utils.getText(context, 'send_pac')}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ))
    ]);
  }

  verifyPac() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.grey,
          ),
          onPressed: () => pageStream.add('email'),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset('drawable/email_icon.png', height: 200),
                ),
                Text(
                  '${Utils.getText(context, 'email_verification')}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  '${Utils.getText(context, 'email_verification_description')}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r"^\d*\.?\d*")),
                  ],
                  controller: pac,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.verified_user),
                    labelText: '${Utils.getText(context, 'pac_no')}',
                    labelStyle: const TextStyle(fontSize: 16, color: Colors.black54),
                    hintText: '',
                    border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                  ),
                  style: const TextStyle(color: Colors.black87),
                ),
                Text(
                  "${Utils.getText(context, 'click_to_resend')}",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      primary: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => checkPac(context),
                    child: Text(
                      '${Utils.getText(context, 'verify_email')}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  resetPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        IconButton(
          icon: const Icon(
            Icons.close,
            color: Colors.grey,
          ),
          onPressed: () => pageStream.add('pac'),
        ),
        Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                  child: Image.asset('drawable/change_password_icon.png', height: 200),
                ),
                Text(
                  '${Utils.getText(context, 'reset_password')}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  '${Utils.getText(context, 'reset_password_description')}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: newPassword,
                  obscureText: hideNewPassword,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: '${Utils.getText(context, 'new_password')}',
                    labelStyle: const TextStyle(fontSize: 16, color: Colors.black54),
                    hintText: '',
                    border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            hideNewPassword = !hideNewPassword;
                          });
                        }),
                  ),
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  obscureText: hideConfirmPassword,
                  controller: confirmPassword,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.verified_user),
                    labelText: '${Utils.getText(context, 'confirmation_password')}',
                    labelStyle: const TextStyle(fontSize: 16, color: Colors.black54),
                    hintText: '',
                    border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                    suffixIcon: IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () {
                          setState(() {
                            hideConfirmPassword = !hideConfirmPassword;
                          });
                        }),
                  ),
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 50.0,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      primary: Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => updatePassword(context),
                    child: Text(
                      '${Utils.getText(context, 'update_password')}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ))
      ],
    );
  }

  /*
  * send pac via email
  * */
  sendPac(context) async {
    pacNumber = (Random().nextInt(900000) + 100000).toString();
    Map data = await Domain().sendPac(email.text, pacNumber);

    if (data['status'] == '1') {
      Utils.showSnackBar(context, 'pac_sent');
      pageStream.add('pac');
    } else {
      Utils.showSnackBar(context, 'invalid_email');
    }
  }

  checkPac(context) {
    if (pac.text == pacNumber) {
      Utils.showSnackBar(context, 'verify_success');
      pageStream.add('reset');
    } else {
      Utils.showSnackBar(context, 'invalid_pac_number');
    }
  }

  updatePassword(context) async {
    if (newPassword.text.isNotEmpty) {
      if (newPassword.text == confirmPassword.text) {
        Map data = await Domain().setNewPassword(newPassword.text, email.text);
        if (data['status'] == '1') {
          Utils.showSnackBar(context, 'password_update_success');
          Navigator.pushReplacementNamed(context, '/login');
        } else {
          Utils.showSnackBar(context, 'something_went_wrong');
        }
      } else {
        Utils.showSnackBar(context, 'password_not_match');
      }
    } else {
      Utils.showSnackBar(context, 'all_field_required');
    }
  }
}
