import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voxta_app/auth/login_screen.dart';
import 'package:voxta_app/home/home_screen.dart';
import 'package:voxta_app/main.dart';

class SplashProvider extends ChangeNotifier{

  Future<void> hold(BuildContext context)async{
    await Future.delayed(Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Future<void> isUserLoggedIn(BuildContext context)async{
    final _prefs = await SharedPreferences.getInstance();
    final isLogged = _prefs.getBool(SAVE_KEY_VALUE);
    if(isLogged == false || isLogged == null){
      hold(context);
    }else{
     Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    }
  }
}