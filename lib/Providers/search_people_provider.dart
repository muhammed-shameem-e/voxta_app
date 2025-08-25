import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:voxta_app/Providers/follow_provider.dart';
import 'package:voxta_app/model_classes.dart/usermodel.dart';

class SearchPeopleProvider extends ChangeNotifier{
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'user';
  List<UserDetails> _users = [];
  List<UserDetails> _filteredUsers = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String? _error;
  String _currentUserId = '';
  FollowProvider? _followProvider;

  String get currentUserId => _currentUserId;
  List<UserDetails> get users => _users;
  List<UserDetails> get filteredUsers => _filteredUsers;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  String? get error => _error;

  void setFollowProvider(FollowProvider followProvider){
    _followProvider = followProvider;
  }

  void setCurrentUserId(String? userId){
    if(userId != null && _currentUserId != userId){
      _currentUserId = userId;
      // Clear existing data when user changes
      _users.clear();
      _filteredUsers.clear();
      _searchQuery = '';
      _error = null;
      notifyListeners();
    }
  }

 Future<void>initializeUsers() async {
    if(_currentUserId.isEmpty) return;
    
    _isLoading = true;
    _error = null;
    notifyListeners();

    getAllUsers(currentUserId: _currentUserId).listen(
      (user) {
        _users = user;
        filterUsers();
        _isLoading = false;
        _error = null;
        notifyListeners();
      },
      onError: (error){
        _error = error.toString();
        _isLoading = false;
        notifyListeners();
      }
    );
  }

  void search(String query){
    _searchQuery = query;
    filterUsers();
    notifyListeners();
  }

  void clearError(){
    _error = null;
    notifyListeners();
  }

  Stream<List<UserDetails>> getAllUsers({String? currentUserId}){
    return _firestore
    .collection(_collection)
    .snapshots()
    .map((snapshot) => snapshot.docs
    .map((doc) => UserDetails.fromMap(doc.data(),documentId: doc.id))
    .where((user) => user.id != currentUserId)
    .toList());
  }

  Stream<List<UserDetails>> searchUsers(String query){

    if(query.isEmpty){
      return getAllUsers(currentUserId: _currentUserId);
    }

    return _firestore
    .collection(_collection)
    .where('name', isGreaterThanOrEqualTo: query)
    .where('name', isLessThanOrEqualTo: query + '\uf8ff')
    .snapshots()
    .map((snapshot) => snapshot.docs
    .map((doc) => UserDetails.fromMap(doc.data(),documentId: doc.id))
    .where((user) => user.id != _currentUserId)
    .toList());
  }

    // Updated filterUsers method
  void filterUsers() {
    if (_searchQuery.isEmpty) {
      _filteredUsers = List.from(_users);
    } else {
      _filteredUsers = _users
          .where((user) =>
              (user.name?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
              (user.username?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
              (user.bio?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
          .toList();
    }
    
    // // Filter out users that current user is already following
    // if (_followProvider != null && _followProvider!.currentUserDetails != null) {
    //   _filteredUsers = _filteredUsers.where((user) {
    //     final buttonText = _followProvider!.getButtonText(_followProvider!.currentUserDetails!, user);
    //     // Only show users where status is NOT 'Following'
    //     return buttonText != 'Following';
    //   }).toList();
    // }
  }
  void reset() {
    _users.clear();
    _filteredUsers.clear();
    _currentUserId = '';
    _searchQuery = '';
    _error = null;
    _isLoading = false;
    _followProvider = null;
    notifyListeners();
  }
}