import 'package:flutter/material.dart';
import 'package:voxta_app/textStyles.dart';

class ChatScreenAppBar extends StatelessWidget implements PreferredSizeWidget{
  const ChatScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
              },
              child: Icon(Icons.arrow_back)),
            const SizedBox(width:10),
            CircleAvatar(
              backgroundColor: Color(0xFF22C55E),
              radius: 20,
            ),
            const SizedBox(width: 10),
            Column(
              children: [
                Text(
                  'David',
                  style: TextStyles.blktxt,
                ),
                const SizedBox(height: 5),
                Text(
                  '..is Typing',
                  style: TextStyle(
                    color: Color(0xFF22C55E),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            Spacer(),
            Icon(Icons.more_horiz,),
          ],
        ),
      ),
    );
  }

@override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}