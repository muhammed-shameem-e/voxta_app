import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voxta_app/Providers/home_provider.dart';
import 'package:voxta_app/textStyles.dart';

class StatusList extends StatelessWidget {
  const StatusList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeProvider>(
      builder: (context,homeProvider,child){
        final scrollController = ScrollController();

        WidgetsBinding.instance.addPostFrameCallback((_){
          homeProvider.setScrollController(scrollController);
        });

      return  Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: ListView.separated(
                controller: scrollController,
                itemBuilder: (ctx,index){
                  return GestureDetector(
                    onTap: (){
                    },
                    child: index == 0?
                    ListTile(
                leading: GestureDetector(
                  onTap: (){
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white,
                        width: 1,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundColor: Color.fromARGB(255, 165, 165, 165),
                      child: Center(
                        child: Icon(Icons.add,color: Colors.white),
                      ),
                    ),
                  ),
                ),
                title: Text(
                  'My status',
                  style: TextStyles.blktxt,
                ),
                subtitle: const Text(
                  'Tap to add status update',
                  style: TextStyle(
                    color: Colors.black,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ):
                    ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xFF22C55E),
                            width: 1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFF22C55E),
                        ),
                      ),
                      title: Text(
                        'David', 
                        style: TextStyles.blktxt,
                      ),
                      subtitle: const Text(
                        '3:17 PM',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                }, 
                separatorBuilder: (ctx,index){
                  return const SizedBox(height: 5);
                },
                itemCount: 20),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF22C55E),
          onPressed: (){
          },
          child: const Icon(Icons.add_a_photo,color: Colors.white),
        ),
      );
      },
    );
  }
}