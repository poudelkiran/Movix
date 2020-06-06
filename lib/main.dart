import 'package:flutter/material.dart';
import 'package:movix/Routes/route_generator.dart';
import 'Utilities/Constant/constants.dart';
import 'Utilities/extensions/colors.dart';

Future<void> main() async {
  /// run setup locator to setup the dependency injection get it
  runApp(MyApp()); 
  }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Constant.movix,
      theme: new ThemeData(
      canvasColor: AppColor.transparentColor
  ),
      initialRoute: AppRoute.home,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}