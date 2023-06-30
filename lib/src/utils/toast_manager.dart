import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastManager {
  // singleton pattern
  static final ToastManager _instance = ToastManager._internal();
  factory ToastManager() => _instance;

  ToastManager._internal();

  late FToast _fToast;

  void initFToast(BuildContext context) {
    _fToast = FToast();
    _fToast.init(context);
  }

  FToast get fToast => _fToast;

  void showFToast(
      {ToastGravity gravity = ToastGravity.TOP_RIGHT,
      Duration toastDuration = const Duration(seconds: 2),
      Duration fadeDuration = const Duration(milliseconds: 350),
      Widget Function(BuildContext, Widget)? positionedToastBuilder,
      required Widget child}) {
    _fToast.showToast(
      gravity: ToastGravity.TOP_RIGHT,
      toastDuration: toastDuration,
      fadeDuration: fadeDuration,
      positionedToastBuilder: positionedToastBuilder,
      child: child,
    );
  }
}
