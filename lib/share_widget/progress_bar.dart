import 'package:flutter/material.dart';

class CustomProgressBar extends StatelessWidget {
  const CustomProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(50, 20, 50, 20),
        child: LinearProgressIndicator(
          color: Colors.black,
        ),
      ),
    );
  }
}
