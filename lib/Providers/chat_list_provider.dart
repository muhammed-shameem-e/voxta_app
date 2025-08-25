import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voxta_app/model_classes.dart/usermodel.dart';

class ChatListProvider extends ChangeNotifier{

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  List<String> _getAllFriendsList = [];
  List<UserDetails> _getAllFriendsDetails = [];
  String? _error;

  bool get isLoading => _isLoading;
  List<String> get getAllFriendsList => _getAllFriendsList;
  List<UserDetails> get getAllFriendsDetails => _getAllFriendsDetails;
  String? get error => _error;

  Future<void> getAllFriends(String currentUserId) async {
    _isLoading = false;
    notifyListeners();
    try {
      final following = await _firestore.collection('user').doc(currentUserId).get();
      if(following.exists){
        final data = following.data() as Map<String,dynamic>;
        final friends = List<String>.from(data['following'] ?? []);
        _getAllFriendsList = friends;
        _getAllFriendsDetails.clear();
        for(String userId in _getAllFriendsList){
          final doc = await _firestore.collection('user').doc(userId).get();
          if(doc.exists){
            _getAllFriendsDetails.add(UserDetails.fromMap(doc.data()!,documentId: doc.id));
          }
        }
      }
      _getAllFriendsDetails = _getAllFriendsDetails.reversed.toList();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      throw Exception('Something went wrong');
    }
  }
}