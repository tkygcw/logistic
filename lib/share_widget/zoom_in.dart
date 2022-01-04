import 'package:driver_app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:photo_view/photo_view.dart';

class ZoomIn extends StatelessWidget {
  final String image;
  final String label;

  // ignore: use_key_in_widget_constructors
  const ZoomIn({required this.image, required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          // ignore: unnecessary_null_comparison
          label,
          style: GoogleFonts.cantoraOne(
            textStyle: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.orangeAccent),
        actions: <Widget>[
          TextButton(
            child: Text(
              Utils.getText(context, 'close'),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: PhotoView(
        initialScale: 0.2,
        imageProvider: NetworkImage(image),
//        errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
//          return Center(
//              child: Icon(
//            Icons.image,
//            color: Colors.white38,
//            size: 100,
//          ));
//        },
      ),
    );
  }
}
