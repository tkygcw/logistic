import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var currentPassword = TextEditingController();
  var newPassword = TextEditingController();
  var confirmPassword = TextEditingController();

  bool hideCurrentPassword = true;
  bool hideNewPassword = true;
  bool hideConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            '${Utils.getText(context, 'update_password')}',
            style: GoogleFonts.acme(
              textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.teal),
            ),
          ),
        ),
        body: Builder(builder: (BuildContext innerContext) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Card(
                  elevation: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 5,
                            ),
                            Image.asset(
                              'drawable/reset_password.png',
                              height: 150,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '${Utils.getText(context, 'update_password_label')}',
                              style: TextStyle(
                                color: Colors.grey[400],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                        child: Column(
                          children: <Widget>[
                            TextField(
                              controller: currentPassword,
                              obscureText: hideCurrentPassword,
                              autocorrect: false,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline),
                                labelText: '${Utils.getText(context, 'current_password')}',
                                labelStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                                hintText: '${Utils.getText(context, 'current_password')}',
                                border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                                suffixIcon: IconButton(
                                    icon: const Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      setState(() {
                                        hideCurrentPassword = !hideCurrentPassword;
                                      });
                                    }),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: newPassword,
                              obscureText: hideNewPassword,
                              autocorrect: false,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline),
                                labelText: '${Utils.getText(context, 'new_password')}',
                                labelStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                                hintText: '${Utils.getText(context, 'new_password')}',
                                border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    setState(() {
                                      hideNewPassword = !hideNewPassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextField(
                              controller: confirmPassword,
                              obscureText: hideConfirmPassword,
                              autocorrect: false,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_outline),
                                labelText: '${Utils.getText(context, 'confirm_password')}',
                                labelStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
                                hintText: '${Utils.getText(context, 'confirm_password')}',
                                border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.remove_red_eye),
                                  onPressed: () {
                                    setState(() {
                                      hideConfirmPassword = !hideConfirmPassword;
                                    });
                                  },
                                ),
                              ),
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
                                onPressed: () => updatePassword(),
                                child: Text(
                                  '${Utils.getText(context, 'reset_password')}',
                                  style: const TextStyle(color: Colors.white),
                                ),
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
          );
        }));
  }

  updatePassword() async {
    if (currentPassword.text.length > 6 && newPassword.text.length > 6 && confirmPassword.text.length > 6) {
      if (newPassword.text == confirmPassword.text) {
        /*
        * update password
        * */
        Map data = await Domain().updatePassword(currentPassword.text, newPassword.text);

        if (data['status'] == '1') {
          Utils.showSnackBar(context, 'update_password');
          currentPassword.clear();
          newPassword.clear();
          confirmPassword.clear();
          /*
          * invalid password
          * */
        } else if (data['status'] == '3') {
          Utils.showSnackBar(context, 'current_password_not_match');
        } else {
          Utils.showSnackBar(context, 'something_went_wrong');
        }
      }
      /*
      * password not match
      * */
      else {
        Utils.showSnackBar(context, 'password_not_match');
      }
    } else {
      Utils.showSnackBar(context, 'password_too_short');
    }
  }
}
