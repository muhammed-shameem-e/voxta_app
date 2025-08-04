import 'package:flutter/material.dart';
import 'package:voxta_app/textStyles.dart';

class GroupList extends StatelessWidget {
  const GroupList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView.separated(
              itemBuilder: (ctx,index){
                return index == 3 
                ? TextButton(
                  onPressed: (){
                  }, 
                  child: const Text(
                    'Create Group',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )):
                GestureDetector(
                  onTap: (){
                  },
                  child: ListTile(
                   leading: GestureDetector(
                    onTap: (){
                    },
                     child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                            width: 1,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 30,
                          backgroundColor: Color(0xFF22C55E),
                          child: Icon(Icons.group,color: Colors.white,size: 30),
                        ),
                      ),
                   ),
                    title: Text(
                      'Real Madrid',
                      style: TextStyles.blktxt,
                    ),
                    subtitle: const Text(
                      'Mbappe: hyy',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    trailing: Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            height: 15,
                            width: 15,
                            decoration: const BoxDecoration(
                              color: Color(0xFF22C55E),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Text(
                                '12',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 7.5,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '6:14 PM',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }, 
              separatorBuilder: (ctx,index){
                return const SizedBox(height: 5);
              },
              itemCount: 4),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF22C55E),
        onPressed: (){
        },
        child: const Icon(Icons.group_add,color: Colors.black),
      ),
    );
  }
}