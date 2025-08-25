import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:voxta_app/model_classes.dart/usermodel.dart';

class NotificationProvider extends ChangeNotifier{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  List<String> _newFollowersList = [];
  List<UserDetails> _newFollowersDetails = [];
  String? _error;

  bool get isLoading => _isLoading;
  List<String> get newFollowersList => _newFollowersList;
  List<UserDetails> get newFollowersDetails => _newFollowersDetails;
  String? get error => _error;

  Future<void> getAllNewFollowers(String currentUserId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final getEveryone = await _firestore.collection('user').doc(currentUserId).get();
      if(getEveryone.exists){
        final data = getEveryone.data() as Map<String,dynamic>;
        final followRequest = List<String>.from(data['followRequest'] ?? []);
        final followers = List<String>.from(data['followers'] ?? []);
        final following = List<String>.from(data['following'] ?? []);
        
        final newFollowers = followers.where((userId) => !following.contains(userId)).toList();
        _newFollowersList = [...followRequest,...newFollowers];
        _newFollowersDetails.clear();
        for(String userId in _newFollowersList){
          final doc = await _firestore.collection('user').doc(userId).get();
          if(doc.exists){
            _newFollowersDetails.add(UserDetails.fromMap(doc.data()!,documentId: doc.id));
          }
        }
      }
      _newFollowersDetails = _newFollowersDetails.reversed.toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      throw Exception('Something went Wrong');
    }
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:voxta_app/model_classes.dart/usermodel.dart';
// import 'package:voxta_app/textStyles.dart';

// class NotificationProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   bool _isLoading = false;
//   List<String> _newFollwersList = [];
//   List<UserDetails> _newFollowerDetails = []; 
//   String? _error;
//   UserDetails? _currentUserDetails;
//   bool _isInitialized = false; // Add initialization flag
  
//   bool get isLoading => _isLoading;
//   List<String> get newFollowersList => _newFollwersList;
//   List<UserDetails> get newFollowerDetails => _newFollowerDetails;
//   String? get error => _error;
//   UserDetails? get currentUserDetails => _currentUserDetails;
//   bool get isInitialized => _isInitialized;

//   void clearError() {
//     _error = null;
//     notifyListeners();
//   }

//   void _setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }

//   void _setError(String error) {
//     _error = error;
//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> acceptFollowRequest(String currentUserId, String requesterUserId) async {
//     try {
//       await _firestore.collection('user').doc(currentUserId).update({
//         'followRequest': FieldValue.arrayRemove([requesterUserId]),
//         'followers': FieldValue.arrayUnion([requesterUserId])
//       });

//       await _firestore.collection('user').doc(requesterUserId).update({
//         'following': FieldValue.arrayUnion([currentUserId])
//       });

//       // Update local state
//       _currentUserDetails?.followRequest?.remove(requesterUserId);
//       _currentUserDetails?.followers?.add(requesterUserId);

//       _newFollowerDetails.removeWhere((user) => user.uid == requesterUserId);
//       notifyListeners();
//     } catch (e) {
//       _setError('Failed to accept follow request: ${e.toString()}');
//     }
//   }

//   Future<void> rejectFollowRequest(String currentUserId, String requesterUserId) async {
//     try {
//       await _firestore.collection('user').doc(currentUserId).update({
//         'followRequest': FieldValue.arrayRemove([requesterUserId])
//       });

//       // Update local state
//       _currentUserDetails?.followRequest?.remove(requesterUserId);
//       _newFollowerDetails.removeWhere((userId) => userId.uid == requesterUserId);
//       notifyListeners();
//     } catch (e) {
//       _setError('Failed to reject follow request: ${e.toString()}');
//     }
//   }

//   Future<void> getNewFollowers(String currentUserId) async {
//     try {
//       final newFollowers = await _firestore.collection('user')
//           .doc(currentUserId)
//           .get();
          
//       if (newFollowers.exists) {
//         final data = newFollowers.data() as Map<String, dynamic>;
//         final requesters = List<String>.from(data['followRequest'] ?? []);
//         final followers = List<String>.from(data['followers'] ?? []);
//         final following = List<String>.from(data['following'] ?? []);

//         final pendingRequests = requesters;
//         final newFollowersNotFollowedBack = followers.where((userId) => !following.contains(userId)).toList();
      
//         _newFollwersList = [...pendingRequests, ...newFollowersNotFollowedBack];
//       }
//     } catch (e) {
//       throw Exception('Failed to get new followers: ${e.toString()}');
//     }
//   }

//   Future<void> loadNewFollwers(String currentUserId) async {
//     if (_isLoading) return; // Prevent multiple simultaneous calls
    
//     _setLoading(true);
//     _error = null;

//     try {
//       await getNewFollowers(currentUserId);

//       _newFollowerDetails.clear();
//       for (String userId in _newFollwersList) {
//         final doc = await _firestore.collection('user').doc(userId).get();
//         if (doc.exists) {
//           _newFollowerDetails.add(UserDetails.fromMap(doc.data()!, documentId: doc.id));
//         }
//       }
//       _newFollowerDetails = _newFollowerDetails.reversed.toList();
//       _isInitialized = true;
//     } catch (e) {
//       _setError('Failed to load notifications: ${e.toString()}');
//       return;
//     }
    
//     _setLoading(false);
//   }

//   Future<void> fetchCurrentUserDetails(String uid) async {
//     if (_currentUserDetails != null) return; // Already fetched
    
//     try {
//       final details = await _firestore.collection('user').doc(uid).get();
//       if (details.exists) {
//         _currentUserDetails = UserDetails.fromMap(details.data()!, documentId: details.id);
//         notifyListeners();
//       }
//     } catch (e) {
//       _setError('Failed to fetch user details: ${e.toString()}');
//     }
//   }

//   Future<void> declineNewFreind(BuildContext context, String currentUserId, String targetUserId) async {
//     showModalBottomSheet(
//       context: context, 
//       builder: (context) {
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
//                   'This will decline the request. Do you want to proceed?',
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 20),
//                 Row(
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         minimumSize: Size(150, 50),
//                       ),
//                       onPressed: () {
//                         Navigator.of(context).pop();
//                       }, 
//                       child: Text(
//                         'Cancel',
//                         style: TextStyles.blktxt,
//                       )
//                     ),
//                     const SizedBox(width: 10),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color.fromARGB(255, 252, 222, 178),
//                         minimumSize: Size(150, 50),
//                         shape: RoundedRectangleBorder(
//                           side: BorderSide(
//                             width: 2,
//                             color: Colors.orange,
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                         )
//                       ),
//                       onPressed: () async {
//                         Navigator.of(context).pop();
//                         await rejectFollowRequest(currentUserId, targetUserId);
//                       }, 
//                       child: Text(
//                         'Remove',
//                         style: TextStyles.blktxt,
//                       )
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         );
//       }
//     );
//   }

//   // Method to refresh data
//   Future<void> refresh(String currentUserId) async {
//     _isInitialized = false;
//     await loadNewFollwers(currentUserId);
//   }
// }