import 'package:flutter/material.dart';

class NotFound extends StatelessWidget {
  final String title, description, drawable, button;
  final bool showButton;
  final Function refresh;

  const NotFound(
      {Key? key,
      required this.title,
      required this.description,
      required this.drawable,
      required this.button,
      required this.refresh,
      required this.showButton})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(drawable),
          const SizedBox(
            height: 20,
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Visibility(
            visible: showButton,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
              child: SizedBox(
                width: double.infinity,
                height: 50.0,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.teal, //Color of the border
                      style: BorderStyle.solid, //Style of the border
                      width: 0.8, //width of the border
                    ),
                    primary: Colors.teal,
                  ),
                  onPressed: () => refresh(),
                  child: Text(
                    button,
                    style: const TextStyle(color: Colors.teal),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
