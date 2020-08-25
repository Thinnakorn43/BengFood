import 'package:flutter/material.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
    context: context,
    builder: (context) {
      var redAccent = Colors.redAccent;
      return SimpleDialog(
        title: Text(message),
        children: <Widget>[
          FlatButton(
            onPressed: () => Navigator.pop(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'OK',
                  style: TextStyle(color: redAccent),
                ),
              ],
            ),
          )
        ],
      );
    },
  );
}
