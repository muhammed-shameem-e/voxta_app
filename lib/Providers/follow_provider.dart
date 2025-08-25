import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voxta_app/Providers/notification_provider.dart';
import 'package:voxta_app/model_classes.dart/usermodel.dart';
import 'package:voxta_app/textStyles.dart';

class FollowProvider extends ChangeNotifier{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserDetails> _voxtaFriendsDetails = [];
  List<String> _voxtaFriendsList = [];
  bool _isLoading = false;
  UserDetails? _currentUserDetails;
  String _searchQuery = '';
  String? _error;

  List<UserDetails> get voxtaFriendsDetails => _voxtaFriendsDetails;
  List<String> get voxtaFriendsList => _voxtaFriendsList;
  bool get isLoading => _isLoading;
  UserDetails? get currentUserDetails => _currentUserDetails;
  String get searchQuery => _searchQuery;
  String? get error => _error;

  Future<void> declineFollwers(String currentUserId,String targetUserId,) async {
    try {
      await _firestore.collection('user').doc(currentUserId).update({
        'followRequest': FieldValue.arrayRemove([targetUserId])
      });
    } catch (e) {
      throw Exception('Something went wrong');
    }
  }

  Future<void> acceptFollowers(String currentUserId,String targetUserId) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firestore.collection('user').doc(currentUserId).update({
        'followRequest': FieldValue.arrayRemove([targetUserId])
      });
      await _firestore.collection('user').doc(currentUserId).update({
        'followers': FieldValue.arrayUnion([targetUserId])
      });
      await _firestore.collection('user').doc(targetUserId).update({
        'following': FieldValue.arrayUnion([currentUserId])
      });
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Something went wrong...');
    }
  }

  List<UserDetails> get filteredUsers {
    if(_searchQuery.isEmpty){
      return _voxtaFriendsDetails;
    }
    return _voxtaFriendsDetails.where((user){
      final name = user.name?.toLowerCase() ?? '';
      final username = user.username?.toLowerCase() ?? '';
      return name.contains(_searchQuery.toLowerCase()) || username.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void search(String query) {
  _searchQuery = query;
  notifyListeners(); 
  }

  Future<void> getVoxtaFriends(String currentUserId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final getEveryone = await _firestore.collection('user').doc(currentUserId).get();
      final allUsers = await _firestore.collection('user').get();
      if(getEveryone.exists){
        final data = getEveryone.data() as Map<String,dynamic>;
        final following = List<String>.from(data['following'] ?? []);
        final List<String> allUserIds = allUsers.docs.map((doc) => doc.id).toList();
        
        final everyone = allUserIds
        .where((userId) => userId != currentUserId && !following.contains(userId))
        .toList();

        _voxtaFriendsList = everyone;
        _voxtaFriendsDetails.clear();
        for(String userId in _voxtaFriendsList){
          final doc = await _firestore.collection('user').doc(userId).get();
          if(doc.exists){
            _voxtaFriendsDetails.add(UserDetails.fromMap(doc.data()!,documentId: doc.id));
          }
        }
      }
      _voxtaFriendsDetails = _voxtaFriendsDetails.reversed.toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      throw Exception('Something went Wrong');
    }
  }

  String getButtonText(UserDetails currentUser, UserDetails otherUser) {
    // Follow back: they follow you, but you don't follow them
    if (currentUser.followers!.contains(otherUser.uid) &&
        !currentUser.following!.contains(otherUser.uid)) {
      return 'Follow Back';
    }

    // Already following
    if (currentUser.following!.contains(otherUser.uid)) {
      return 'Following';
    }

    // Requested for private account
    if (otherUser.isPrivate! &&
        otherUser.followRequest!.contains(currentUser.uid)) {
      return 'Requested';
    }

    if(currentUser.followRequest!.contains(otherUser.uid)){
      return 'Accept';
    }
    return 'Follow';
  }

  Future<void> sendFollowRequest(
    UserDetails currentUser,
    UserDetails targetUser,
    bool isPrivate,
    String currentUserId,
    String targetUserId,
    NotificationProvider provider,
  ) async {
    _isLoading = true;
    notifyListeners();
    try {
      final buttonText = getButtonText(currentUser, targetUser);
    if(buttonText == 'Follow' || buttonText == 'Follow Back'){
      if(isPrivate){
        await _firestore.collection('user').doc(targetUserId).update({
          'followRequest': FieldValue.arrayUnion([currentUserId]),
        });
      }else{
        await _firestore.collection('user').doc(currentUserId).update({
          'following': FieldValue.arrayUnion([targetUserId])
        });
        Future.delayed(const Duration(seconds: 3), () {
        voxtaFriendsDetails.remove(targetUser);
        provider.newFollowersDetails.remove(targetUser);
        notifyListeners();
        });
        await _firestore.collection('user').doc(targetUserId).update({
          'followers': FieldValue.arrayUnion([currentUserId])
        });
      }
    } else if(buttonText == 'Requested'){
      await _firestore.collection('user').doc(targetUserId).update({
        'followRequest': FieldValue.arrayRemove([currentUserId])
      });
    } else if(buttonText == 'Accept'){
      await acceptFollowers(currentUserId, targetUserId);
    }
    _isLoading = false;
    notifyListeners();
    } catch (e) {
    _isLoading = false;
    notifyListeners();
      throw Exception('Something went Wrong');
    }
  }

  Future<void> fetchCurrentUserDetails(String uid) async {
    try {
      final details = await FirebaseFirestore.instance.collection('user').doc(uid).get();
    if(details.exists){
      _currentUserDetails = UserDetails.fromMap(details.data()!, documentId: details.id);
      notifyListeners();
    }
    } catch (e) {
      throw Exception('Something went Wrong');
    }
  }

    Future<void> removeFriendAlert(
    BuildContext context, 
    String currentUserId, 
    String targetUserId,
    String text,
    UserDetails targetUser,
    NotificationProvider provider) async {
    showDialog(
    context: context, 
    builder: (context){
      return AlertDialog(
        content: Text(
          text
        ),
        actions: [
          TextButton(
            onPressed: (){
              Navigator.of(context).pop();
            },
             child: Text(
              'Cancel',
              style: TextStyles.black,
             )),
          TextButton(
            onPressed: () async {
              if(text == 'Do you want to remove their follow Request'){
                        await declineFollwers(currentUserId, targetUserId);
                        provider.newFollowersDetails.remove(targetUser);
                        provider.notifyListeners();
                        notifyListeners();
                      } 
                      Navigator.of(context).pop();
            }, 
            child: Text(
              'Remove',
              style: TextStyle(
                color: Colors.red,
              ),
            ))
        ],
      );
    });
  }
}


//   Future<void> sendFollowRequest(
//     String currentUserId,
//     String targetUserId,
//     bool isPrivate,
//     UserDetails? currentUser,
//     UserDetails? targetUser,
//     BuildContext context) async{

//     final buttonText = getButtonText(currentUser!, targetUser!);
    
//     if (!isPrivate && (buttonText == 'Follow' || buttonText == 'Follow Back')){
//       await _firestore.collection('user').doc(currentUserId).update({
//         'following': FieldValue.arrayUnion([targetUserId])
//       });

//       await _firestore.collection('user').doc(targetUserId).update({
//         'followers': FieldValue.arrayUnion([currentUserId])
//       });

//       // Update currentUserDetails following list for button text updates
//       _currentUserDetails?.following?.add(targetUserId);
//       // Update targetUser followers list for instant button text update
//       targetUser.followers?.add(currentUserId);
      
//       // Only notify listeners for button text update, don't trigger page refresh
//       notifyListeners();

//     } else if(isPrivate && buttonText == 'Follow'){
//       await _firestore.collection('user').doc(targetUserId).update({
//         'followRequest': FieldValue.arrayUnion([currentUserId])
//       });
      
//       // Update targetUser followRequest list for instant button text update
//       targetUser.followRequest?.add(currentUserId);
//       // Only notify listeners for button text update
//       notifyListeners();

//     } else if(buttonText == 'Following'){
//       // Fix: Handle both private and public accounts
//       if(isPrivate) {
//         unfollowAlertDailogue(context, currentUserId, targetUserId, targetUser);
//       } else {
//         // For public accounts, unfollow directly
//         await unFollow(context, currentUserId, targetUserId, targetUser);
//       }
//     } else if(buttonText == 'Requested') {
//       // Handle cancel request for private accounts
//       await _firestore.collection('user').doc(targetUserId).update({
//         'followRequest': FieldValue.arrayRemove([currentUserId])
//       });
      
//       // Update targetUser followRequest list for instant button text update
//       targetUser.followRequest?.remove(currentUserId);
//       // Only notify listeners for button text update
//       notifyListeners();
//     }
//   }

//   Future<void> unFollow(BuildContext context, String currentUserId, String targetUserId, [UserDetails? targetUser]) async {
//     await _firestore.collection('user').doc(currentUserId).update({
//       'following': FieldValue.arrayRemove([targetUserId])
//     });
    
//     await _firestore.collection('user').doc(targetUserId).update({
//       'followers': FieldValue.arrayRemove([currentUserId])
//     });

//     // Update currentUserDetails following list
//     _currentUserDetails?.following?.remove(targetUserId);
//     // Update targetUser followers list for instant button text update
//     targetUser?.followers?.remove(currentUserId);
    
//     // Only notify listeners for button text update
//     notifyListeners();
    
//     // Only show remove friend alert if they were following each other
//     if (_currentUserDetails?.followers?.contains(targetUserId) == true) {
//       await removeFriendAlert(context, currentUserId, targetUserId);
//     }
//   }

//   Future<void> removeFromFollower(String currentUserId, String targetUserId) async {
//     await _firestore.collection('user').doc(currentUserId).update({
//       'followers': FieldValue.arrayRemove([targetUserId])
//     });
    
//     // Update currentUserDetails followers list
//     _currentUserDetails?.followers?.remove(targetUserId);
//     notifyListeners();
//   }

//   Future<void> unfollowAlertDailogue(BuildContext context, String currentUserId, String targetUserId, [UserDetails? targetUser]) async{
//     showModalBottomSheet(
//       context: context, 
//       builder: (context){
//         return Container(
//           height: 170,
//           width: double.infinity,
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(20),
//               topRight: Radius.circular(20),
//             ),
//             color: Colors.white,
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               children: [
//                 Text(
//                   'This is a private account\nUnfollowing will require a new follow request.',
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                      ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.white,
//                       minimumSize: Size(150, 50),
//                     ),
//                     onPressed: (){
//                       Navigator.of(context).pop();
//                     }, 
//                     child: Text(
//                       'Cancel',
//                       style: TextStyles.blktxt,
//                     )),
//                     const SizedBox(width: 10),
//                      ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Color.fromARGB(255, 252, 222, 178),
//                       minimumSize: Size(150, 50),
//                       shape: RoundedRectangleBorder(
//                         side: BorderSide(
//                           width: 2,
//                           color: Colors.orange,
//                         ),
//                         borderRadius: BorderRadius.circular(20),
//                       )
//                     ),
//                     onPressed: () async{
//                       Navigator.of(context).pop();
//                       await unFollow(context, currentUserId, targetUserId, targetUser);
//                     }, 
//                     child: Text(
//                       'Unfollow',
//                       style: TextStyles.blktxt,
//                     )),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       });
//   }


// }