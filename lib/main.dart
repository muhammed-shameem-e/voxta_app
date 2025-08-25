import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voxta_app/Providers/Login_provider.dart';
import 'package:voxta_app/Providers/chat_list_provider.dart';
import 'package:voxta_app/Providers/follow_provider.dart';
import 'package:voxta_app/Providers/home_provider.dart';
import 'package:voxta_app/Providers/notification_provider.dart';
import 'package:voxta_app/Providers/search_people_provider.dart';
import 'package:voxta_app/Providers/splash_provider.dart';
import 'package:voxta_app/firebase_options.dart';
import 'package:voxta_app/splash_screen.dart';

const SAVE_KEY_VALUE = 'userLoggedIn';

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SplashProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => SearchPeopleProvider()),
        ChangeNotifierProvider(create: (context) => FollowProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
        ChangeNotifierProvider(create: (context) => ChatListProvider()),
      ],
      child: MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}