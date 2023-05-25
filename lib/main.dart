import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:launchlab/src/config/app_router.dart';
import 'package:launchlab/src/config/app_theme.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: appThemeData,
      routerConfig: appRouter,
    );
  }
}
