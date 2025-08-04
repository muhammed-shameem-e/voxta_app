import 'package:flutter/material.dart';
import 'package:voxta_app/Providers/splash_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  final SplashProvider splashProvider = SplashProvider();

  @override
  void initState() {
    splashProvider.isUserLoggedIn(context);  
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8FFFB),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Image.asset(
          'asset/logowithname.png',
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}