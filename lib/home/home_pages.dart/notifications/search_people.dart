import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voxta_app/Providers/follow_provider.dart';
import 'package:voxta_app/Providers/notification_provider.dart';
import 'package:voxta_app/textStyles.dart';

class SearchPeople extends StatelessWidget {
  const SearchPeople({super.key});

  @override
  Widget build(BuildContext context) {
    
    WidgetsBinding.instance.addPostFrameCallback((_){
      final currentUser = FirebaseAuth.instance.currentUser!.uid;
      final followProvider = Provider.of<FollowProvider>(context,listen: false);
      followProvider.getVoxtaFriends(currentUser);
    });
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextFormField(
              onChanged: (value) {
                Provider.of<FollowProvider>(context,listen: false).search(value);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Icon(Icons.arrow_back),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF22C55E)),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF22C55E)),
                  borderRadius: BorderRadius.circular(20),
                ),
                floatingLabelStyle: const TextStyle(
                  color: Color(0xFF22C55E),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Consumer<FollowProvider>(
                builder: (context,followProvider,child){
                  if(followProvider.isLoading){
                    return Center(
                      child: CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    );
                  }

                  if(followProvider.voxtaFriendsDetails.isEmpty){
                    return Center(
                      child: Text(
                        'Oops...something went wrong...',
                      ),
                    );
                  }

                  // if(followProvider.error!.isNotEmpty){
                  //   return Center(
                  //     child: Text(
                  //       'error: ${followProvider.error}',
                  //     ),
                  //   );
                  // }
                  return ListView.separated(
                  itemCount: followProvider.filteredUsers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final user = followProvider.filteredUsers[index];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              radius: 30,
                              backgroundColor: Color(0xFF22C55E),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.username ?? "Unknown",
                                    style: TextStyles.blktxt,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    (user.bio != null && user.bio!.trim().isNotEmpty)
                                    ? user.bio!
                                    : 'Have a good day', 
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  const SizedBox(height: 5),
                                  Consumer<FollowProvider>(
                                    builder: (context,followProvider,child){
                                      final currentUserId = FirebaseAuth.instance.currentUser!.uid;
                                      final notificationProvider = Provider.of<NotificationProvider>(context,listen: false);
                                      if(followProvider.currentUserDetails == null){
                                        followProvider.fetchCurrentUserDetails(currentUserId);
                                      }
                                      final buttonText = followProvider.getButtonText(
                                        followProvider.currentUserDetails!,
                                        user,
                                      );
                                      return ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: 
                                        (buttonText == 'Follow' || buttonText == 'Follow Back' || buttonText == 'Accept')
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
                                          notificationProvider);

                                        await followProvider.fetchCurrentUserDetails(currentUserId);
                                      },
                                      child: Text(
                                        buttonText,
                                        style: 
                                        (buttonText == 'Follow' || buttonText == 'Follow Back' || buttonText == 'Accept')
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
                ); 
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
