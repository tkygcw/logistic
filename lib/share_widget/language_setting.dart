import 'package:driver_app/translation/app_language.dart';
import 'package:driver_app/utils/utils.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:group_radio_button/group_radio_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageDialog extends StatefulWidget {
  const LanguageDialog({Key? key}) : super(key: key);

  @override
  _LanguageDialogState createState() => _LanguageDialogState();
}

class _LanguageDialogState extends State<LanguageDialog> {
  var selectedLanguage = 'English';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setSelectedLanguage();
  }

  setSelectedLanguage() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      if (prefs.getString('language_code') == null) {
        selectedLanguage = 'English';
        return;
      }
      selectedLanguage = getLanguage(prefs.getString('language_code'));
      print(selectedLanguage);
      return;
    });
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return AlertDialog(
      title: Text(
        Utils.getText(context, 'language'),
        style: GoogleFonts.cantoraOne(
          textStyle: const TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            RadioGroup<String>.builder(
              groupValue: selectedLanguage,
              onChanged: (value) => setState(() {
                selectedLanguage = value!;
              }),
              items: const <String>[
                "English",
                "中文",
                "Malay",
              ],
              itemBuilder: (item) => RadioButtonBuilder(
                item,
              ),
            ),
//            RadioButtonGroup(
//                labels: const <String>[
//                  "English",
//                  "中文",
//                  "Malay",
//                ],
//                picked: selectedLanguage,
//                onSelected: (String selectedLanguage) {
//                  setState(() {
//                    this.selectedLanguage = selectedLanguage;
//                  });
//                }),
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
            appLanguage.changeLanguage(Locale(getLanguageCode(selectedLanguage)));
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  String getLanguage(selectedLanguage) {
    switch (selectedLanguage) {
      case 'zh':
        return '中文';
      case 'ms':
        return 'Malay';
      default:
        return 'English';
    }
  }

  String getLanguageCode(selectedLanguage) {
    switch (selectedLanguage) {
      case '中文':
        return 'zh';
      case 'Malay':
        return 'ms';
      default:
        return 'en';
    }
  }
}
