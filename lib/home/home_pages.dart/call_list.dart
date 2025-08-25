import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voxta_app/Providers/chat_list_provider.dart';
import 'package:voxta_app/Providers/home_provider.dart';
import 'package:voxta_app/textStyles.dart';

class CallList extends StatelessWidget {
  const CallList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context,homeProvider,child){

      final scrollController = ScrollController();

      WidgetsBinding.instance.addPostFrameCallback((_){
        homeProvider.setScrollController(scrollController);
      });
        return Scaffold(
      backgroundColor: Colors.white,
      body:  Consumer<ChatListProvider>(
        builder: (context,chatListProvider,child){
          return ListView.separated(
          controller: scrollController,
          itemBuilder: (ctx,index){
            return Card(
              color: Colors.white,
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)
              ),
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xFF22C55E)
                  ),
                ),
                title: Text(
                  'David',
                  style: TextStyles.blktxt,
                ),
                subtitle: Row(
                  children: [
                    index % 2 == 0 ?
                    const Icon(Icons.arrow_upward,color: Colors.green,size: 15)
                    : const Icon(Icons.arrow_downward,color: Colors.red,size: 15),
                    Text(
                      '3:51 PM',
                      style: TextStyle(
                        color: index % 2 == 0 ? Colors.green:Colors.red,
                        fontStyle: FontStyle.italic,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
                trailing: index % 2 == 0 ?
                GestureDetector(
                  onTap: (){
                    
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE6F9F0),
                    ),
                    child: const Icon(Icons.call,color: Color(0xFF22C55E))))
                :GestureDetector(
                  onTap: (){
                    
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFE6F9F0),
                    ),
                    child: const Icon(Icons.videocam,color: Color(0xFF22C55E)))),
              ),
            );
          }, 
          separatorBuilder: (ctx,index){
            return const SizedBox(height: 5);
          },
          itemCount: 20); 
        },
      ),
    );
      },
    );
  }
}