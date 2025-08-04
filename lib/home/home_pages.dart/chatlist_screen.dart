import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voxta_app/Providers/home_provider.dart';
import 'package:voxta_app/home/home_pages.dart/chat_screens/chat_screen.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context, homeProvider, child) {
        // Create a scroll controller for this page
        final scrollController = ScrollController();
        
        // Set up the scroll listener in the provider
        WidgetsBinding.instance.addPostFrameCallback((_) {
          homeProvider.setScrollController(scrollController);
        });

        return ListView.separated(
          controller: scrollController,
          itemCount: 50, 
          itemBuilder: (context, index) {
            return ListTile(
              onTap : (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              },
              leading: CircleAvatar(
                backgroundColor: Color(0xFF22C55E),
                child: Text(
                  'U${index + 1}',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              title: Text(
                'Chat ${index + 1}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Last message from chat ${index + 1}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '12:${(index % 60).toString().padLeft(2, '0')}',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  SizedBox(height: 4),
                  if (index % 3 == 0)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Color(0xFF22C55E),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${index % 5 + 1}',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                ],
              ),
            );
          },
          separatorBuilder: (context,index){
            return Divider(
              color: const Color.fromARGB(255, 241, 241, 241),
            );
          },
        );
      },
    );
  }
}