import 'package:flutter/material.dart';
import 'package:voxta_app/textStyles.dart';

class TextMessage extends StatelessWidget {
  const TextMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'Type a message',
            prefixIcon: Icon(Icons.emoji_emotions),
            suffixIcon: Icon(Icons.send,color: Color(0xFF22C55E),),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF22C55E)),
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFF22C55E)),
              borderRadius: BorderRadius.circular(20),
            ),
            floatingLabelStyle: TextStyle(
              color: Color(0xFF22C55E),
            ),
            
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      );
  }
}