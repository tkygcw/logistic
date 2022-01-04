import 'package:driver_app/object/driver.dart';
import 'package:driver_app/share_widget/progress_bar.dart';
import 'package:driver_app/utils/domain.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Driver driver;

  bool isLoading = false;
  var name = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  var address = TextEditingController();
  var postcode = TextEditingController();
  var plateNumber = TextEditingController();
  var status = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDriverProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${Utils.getText(context, 'profile')}',
          style: GoogleFonts.acme(
            textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400, color: Colors.teal),
          ),
        ),
      ),
      body: isLoading
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 35, 20, 35),
                    child: Column(
                      children: <Widget>[
                        TextField(
                          enabled: false,
                          keyboardType: TextInputType.name,
                          controller: name,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.person),
                            labelText: '${Utils.getText(context, 'name')}',
                            labelStyle: const TextStyle(fontSize: 16, color: Colors.teal),
                            hintText: '${Utils.getText(context, 'name')}',
                            border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                          ),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          enabled: false,
                          keyboardType: TextInputType.emailAddress,
                          controller: email,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            labelText: '${Utils.getText(context, 'email')}',
                            labelStyle: const TextStyle(fontSize: 16, color: Colors.teal),
                            hintText: '${Utils.getText(context, 'email')}',
                            border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                          ),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          enabled: false,
                          keyboardType: TextInputType.phone,
                          controller: phone,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.phone_android),
                            labelText: '${Utils.getText(context, 'phone')}',
                            labelStyle: const TextStyle(fontSize: 16, color: Colors.teal),
                            hintText: '${Utils.getText(context, 'contact_number_hint')}',
                            border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                          ),
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          keyboardType: TextInputType.streetAddress,
                          maxLines: 3,
                          controller: address,
                          autocorrect: false,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.location_on),
                            labelText: '${Utils.getText(context, 'address')}',
                            labelStyle: const TextStyle(fontSize: 16, color: Colors.teal),
                            hintText: '${Utils.getText(context, 'address')}',
                            border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          enabled: true,
                          keyboardType: TextInputType.number,
                          controller: postcode,
                          maxLength: 5,
                          textAlign: TextAlign.start,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.home),
                            labelText: '${Utils.getText(context, 'postcode')}',
                            labelStyle: const TextStyle(fontSize: 16, color: Colors.teal),
                            hintText: '${Utils.getText(context, 'postcode')}',
                            border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextField(
                          keyboardType: TextInputType.text,
                          autocorrect: false,
                          controller: plateNumber,
                          textAlign: TextAlign.start,
                          textCapitalization: TextCapitalization.characters,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.directions_car),
                            labelText: '${Utils.getText(context, 'plate_no')}',
                            labelStyle: const TextStyle(fontSize: 16, color: Colors.teal),
                            hintText: '${Utils.getText(context, 'plate_no')}',
                            border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const CustomProgressBar(),
      bottomNavigationBar: BottomAppBar(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          width: double.infinity,
          height: 50.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 0.0,
              primary: Colors.teal,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () {
              checkInput();
            },
            child: Text(
              '${Utils.getText(context, 'update_profile')}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      )),
    );
  }

  getDriverProfile() async {
    Map data = await Domain().driverProfile();
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        if (data['status'] == '1') {
          List responseJson = data['profile'];
          driver = Driver.fromJson(responseJson[0]);
          name.text = driver.name!;
          email.text = driver.email!;
          phone.text = driver.phone!;
          address.text = driver.address!;
          postcode.text = driver.postcode!;
          plateNumber.text = driver.plateNo!;
        }
        isLoading = true;
      });
    }
  }

  checkInput() {
    if (address.text.isNotEmpty && postcode.text.isNotEmpty && plateNumber.text.isNotEmpty) {
      driver.address = address.text;
      driver.postcode = postcode.text;
      driver.plateNo = plateNumber.text;
      updateProfile();
    } else {
      Utils.showSnackBar(context, 'all_field_required');
    }
  }

  updateProfile() async {
    Map data = await Domain().updateProfile(driver);
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      if (data['status'] == '1') {
        Utils.showSnackBar(context, 'update_success');
      }
    });
  }
}
