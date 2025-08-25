import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voxta_app/Providers/follow_provider.dart';
import 'package:voxta_app/Providers/notification_provider.dart';
import 'package:voxta_app/home/home_pages.dart/notifications/search_people.dart';
import 'package:voxta_app/textStyles.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_){
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      final notificationProvider = Provider.of<NotificationProvider>(context,listen: false);
      notificationProvider.getAllNewFollowers(currentUser);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchPeople()));
            },
            icon: Icon(Icons.search, color: Color(0xFF22C55E)),
          )
        ],
        title: Text(
          'Notifications',
          style: TextStyles.blktxt,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Consumer<NotificationProvider>( 
          builder: (context,notificationProvider,child){
            final currentUser = FirebaseAuth.instance.currentUser!.uid;
            final followProvider = Provider.of<FollowProvider>(context,listen: false);
            if(followProvider.currentUserDetails == null){
              followProvider.fetchCurrentUserDetails(currentUser);
            }
                if(notificationProvider.isLoading){
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    );
                  }

                  if(notificationProvider.newFollowersDetails.isEmpty){
                    return Center(
                      child: Text(
                        'You currently have no new followers.',
                      ),
                    );
                  }

                  // if(notificationProvider.error!.isNotEmpty){
                  //   return Center(
                  //     child: Text(
                  //       'error: ${notificationProvider.error}',
                  //     ),
                  //   );
                  // }
            return ListView.separated(
            itemBuilder: (context, index) {
              final user = notificationProvider.newFollowersDetails[index];
              return Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Color(0xFF22C55E),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.username ?? 'David',
                              style: TextStyles.blktxt,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              (user.bio != null && user.bio!.trim().isNotEmpty)
                                    ? user.bio!
                                    : 'Have a good day', 
                              style: TextStyle(color: Colors.black87),
                            ),
                            const SizedBox(height: 5),
                            (followProvider.currentUserDetails!.isPrivate! && followProvider.currentUserDetails!.followRequest!.contains(user.uid)) 
                            ? Consumer<FollowProvider>(
                              builder: (context,followProvider,child){
                               final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                               final notificationProvider = Provider.of<NotificationProvider>(context,listen: false);
                                return Row(
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      minimumSize: Size(80, 35),
                                    ),
                                    onPressed: () async{
                                      await followProvider.acceptFollowers(currentUserId, user.uid!);
                                      await followProvider.fetchCurrentUserDetails(currentUserId);
                                      await notificationProvider.getAllNewFollowers(currentUserId);
                                    },
                                    child: Text(
                                      'Accept',
                                      style: TextStyles.white,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        side: BorderSide(
                                          width: 2,
                                          color: Colors.red,
                                        ),
                                      ),
                                      minimumSize: Size(80, 35),
                                    ),
                                    onPressed: () async{
                                      await followProvider.removeFriendAlert(
                                        context, 
                                        currentUserId, 
                                        user.uid!, 
                                        'Do you want to remove their follow Request', 
                                        user,
                                        notificationProvider,
                                        );
                                    },
                                    child: Text('Decline'),
                                  ),
                                ],
                              ); 
                              },
                            )
                            : Consumer<FollowProvider>(
                                    builder: (context,followProvider,child){
                                      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                                      final notificaton = Provider.of<NotificationProvider>(context,listen: false);
                                      if(followProvider.currentUserDetails == null){
                                        followProvider.fetchCurrentUserDetails(currentUserId);
                                      }
                                      final buttonText = followProvider.getButtonText(
                                        followProvider.currentUserDetails!,
                                        user,
                                      );
                                      return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: (buttonText == 'Follow' || buttonText == 'Follow Back')
                                        ? Colors.green : Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          side: const BorderSide(
                                            width: 2,
                                            color: Colors.green,
                                          ),
                                        ),
                                        minimumSize: const Size(200, 30),
                                      ),
                                      onPressed: () async {
                                        await followProvider.sendFollowRequest(
                                          followProvider.currentUserDetails!, 
                                          user, 
                                          false, 
                                          currentUserId, 
                                          user.uid!,
                                          notificaton);

                                        await followProvider.fetchCurrentUserDetails(currentUserId);
                                      },
                                      child: Text(
                                        buttonText,
                                        style: (buttonText == 'Follow' || buttonText == 'Follow Back')
                                        ? TextStyles.white : TextStyles.black,
                                      ),
                                    ); 
                                    }
                                  )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemCount: notificationProvider.newFollowersDetails.length,
          ); 
          },
        ),
      ),
    );
  }
}
