import 'package:flutter/material.dart';
import 'package:voxta_app/home/home_pages.dart/chat_screens/app_bar.dart';
import 'package:voxta_app/home/home_pages.dart/chat_screens/type_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ChatScreenAppBar(),
      floatingActionButton: TextMessage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}