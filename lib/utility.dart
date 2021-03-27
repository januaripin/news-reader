import 'package:flutter/material.dart';

class Utility {
  static Utility get instance {
    return Utility();
  }

  Future<void> showInfoDialog(BuildContext context, String message) async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
