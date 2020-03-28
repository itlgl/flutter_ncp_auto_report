import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogUtils {
  static void showTipDialog(BuildContext context, String message) {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text('提示'),
            content: Text(message),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('我知道了'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        });
  }
}
