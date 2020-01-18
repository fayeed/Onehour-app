import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/images/icon.png",
          width: MediaQuery.of(context).size.width * 0.5,
        ),
      ),
    );
  }
}
