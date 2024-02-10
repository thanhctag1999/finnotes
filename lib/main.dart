import 'package:finnotes/routes/app_pages.dart';
import 'package:finnotes/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Finnotes",
        initialRoute: AppRoute.LOGIN,
        getPages: getRoutes);
  }
}
