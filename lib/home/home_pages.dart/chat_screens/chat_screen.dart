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
      body: ListView.separated(
        itemBuilder: (context,index){
          return Container(
            height: 100,
            width: 250,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFFF1F1F1),
            ),
          );
        }, 
        separatorBuilder: (context,index){
          return SizedBox(height: 5);
        }, 
        itemCount: 20),
      floatingActionButton: TextMessage(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}