// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MsgScaffold {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> mensaje(
      BuildContext context, String mensaje, Color color, double? width) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      width: width,
      content: Text(mensaje),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(bottom: 40),
    ));
  }
}
