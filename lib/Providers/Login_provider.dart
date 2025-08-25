import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voxta_app/home/home_screen.dart';
import 'package:voxta_app/main.dart';
import 'package:voxta_app/model_classes.dart/usermodel.dart';
import 'package:voxta_app/textStyles.dart';

class LoginProvider extends ChangeNotifier{

  bool _isSee = false;
  bool _isAccept = false;
  File? _profileImage;
  bool _isLoading = false;

  bool get isSee => _isSee;
  bool get isAccept => _isAccept; 
  File? get profileImage => _profileImage;
  bool get isLoading => _isLoading;

  final picker = ImagePicker();

  void makeItVisible(){
    _isSee = !_isSee;
    notifyListeners();
  }

  void isAccepted(){
    _isAccept = !_isAccept;
    notifyListeners();
  }

  void isLoaded(bool value){
    _isLoading = value;
    notifyListeners();
  }

  void remindAcceptTerms(BuildContext context){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xFF2A2A2A),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Please accept the terms & conditions',
          style: TextStyles.white,
        ),
      )
    );
  }

  Future<void> registerUser({
    required UserDetails details,
    required BuildContext context,
  }) async {

    try {
      isLoaded(true);
      final usernameQuery = await FirebaseFirestore.instance
          .collection('user')
          .where('username', isEqualTo: details.username)
          .get();

      if (usernameQuery.docs.isNotEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Color(0xFF2A2A2A),
              duration: Duration(seconds: 3),
              margin: EdgeInsets.all(20),
              behavior: SnackBarBehavior.floating,
              content: Text(
                'Username already exists. Please choose a different username.',
                style: TextStyles.white,
              ),
            ),
          );
        }
        return;
      }

      final emailQuery = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: details.email)
          .get();

      if (emailQuery.docs.isNotEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Color(0xFF2A2A2A),
              duration: Duration(seconds: 3),
              margin: EdgeInsets.all(20),
              behavior: SnackBarBehavior.floating,
              content: Text(
                'E-email already exists. Please choose a different E-email.',
                style: TextStyles.white,
              ),
            ),
          );
        }
        return;
      }
      final credential = await FirebaseAuth.instance.
      createUserWithEmailAndPassword(email: details.email!, password: details.password!);

      final uid = credential.user!.uid;

      final updateUser = details.copyWith(uid: uid);

    // await credential.user!.sendEmailVerification();

    
    await FirebaseFirestore.instance
    .collection('user')
    .doc(credential.user!.uid)
    .set(updateUser.toMap());

    

    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        String errorMessage;
        switch (e.code) {
          case 'weak-password':
            errorMessage = 'The password provided is too weak.';
            break;
          case 'email-already-in-use':
            errorMessage = 'The account already exists for that email.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          default:
            errorMessage = 'Registration failed: ${e.message}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFF2A2A2A),
            duration: Duration(seconds: 3),
            margin: EdgeInsets.all(20),
            behavior: SnackBarBehavior.floating,
            content: Text(
              errorMessage,
              style: TextStyles.white,
            ),
          ),
        );
      }
    }
    catch (e) {
      if(context.mounted){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xFF2A2A2A),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Error: ${e.toString()}',
          style: TextStyles.white,
        ),
      ),
    );
      }
    } finally {
      isLoaded(false);
    }
  }

  Future<void> loginWithUsername({
  required String username,
  required String password,
  required BuildContext context,
}) async {
  try {
    isLoaded(true);
    
    // Find user by username
    final snapshot = await FirebaseFirestore.instance
        .collection('user')
        .where('username', isEqualTo: username)
        .get();

    if (snapshot.docs.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Color(0xFF2A2A2A),
            duration: Duration(seconds: 3),
            margin: EdgeInsets.all(20),
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Incorrect username or password. Try again',
              style: TextStyles.white,
            ),
          ),
        );
      }
      return;
    }

    final email = snapshot.docs.first['email'];

    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final _prefs = await SharedPreferences.getInstance();
    await _prefs.setBool(SAVE_KEY_VALUE, true);

    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false,
      );
    }

  } on FirebaseAuthException catch (e) {
    if (context.mounted) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'Incorrect username or password. Try again';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect username or password. Try again';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many failed attempts. Please try again later.';
          break;
        default:
          errorMessage = 'Login failed: ${e.message}';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF2A2A2A),
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text(
            errorMessage,
            style: TextStyles.white,
          ),
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Color(0xFF2A2A2A),
          duration: Duration(seconds: 3),
          margin: EdgeInsets.all(20),
          behavior: SnackBarBehavior.floating,
          content: Text(
            'Login Failed: ${e.toString()}',
            style: TextStyles.white,
          ),
        ),
      );
    }
  } finally {
    isLoaded(false);
  }
}

  // Future<void> loginWithUsername({
  //   required String username,
  //   required String password,
  //   required BuildContext context,
  // }) async {

  //   try{
  //     isLoaded(true);
  //     final snapshot = await FirebaseFirestore.instance
  //     .collection('user')
  //     .where('username',isEqualTo: username)
  //     .get();

  //     if (snapshot.docs.isEmpty) {
  //          if (context.mounted) {
  //                ScaffoldMessenger.of(context).showSnackBar(
  //                SnackBar(
  //                backgroundColor: Color(0xFF2A2A2A),
  //                duration: Duration(seconds: 3),
  //                margin: EdgeInsets.all(20),
  //                behavior: SnackBarBehavior.floating,
  //                content: Text(
  //                        'Incorrect username or password. Try again',
  //                         style: TextStyles.white,
  //                ),
  //              ),
  //             );
  //           }
  //      return;
  //     }

  //     final email = snapshot.docs.first['email'];

  //     final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: email, 
  //       password: password
  //       );

  //     await credential.user!.reload();

  //     if(!credential.user!.emailVerified){

  //     final unverifiedUser = credential.user!;
  //     await unverifiedUser.sendEmailVerification();


  //       if(context.mounted){
  //       ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //       backgroundColor: Color(0xFF2A2A2A),
  //       duration: Duration(seconds: 6),
  //       margin: EdgeInsets.all(20),
  //       behavior: SnackBarBehavior.floating,
  //       content: Text(
  //         'Please verify your email before logging in. A verification link has been sent to your registered email.',
  //         style: TextStyles.white,
  //       ),
  //       action: SnackBarAction(
  //       label: 'Resend',
  //       textColor: Colors.white, 
  //       onPressed: () async {
  //         try {
  //         await credential.user!.sendEmailVerification();

  //         if(context.mounted){
  //           ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       backgroundColor: Color(0xFF2A2A2A),
  //       duration: Duration(seconds: 3),
  //       margin: EdgeInsets.all(20),
  //       behavior: SnackBarBehavior.floating,
  //       content: Text(
  //         'A verification email has been sent to your registered email',
  //         style: TextStyles.white,
  //       ),
  //     ),
  //   );
  //         }
  //         } catch (e) {
  //           if(context.mounted){
  //           ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         backgroundColor: Color(0xFF2A2A2A),
  //         duration: Duration(seconds: 3),
  //         margin: EdgeInsets.all(20),
  //         behavior: SnackBarBehavior.floating,
  //         content: Text(
  //           'Failed to resend verification email: ${e.toString()}',
  //           style: TextStyles.white,
  //         ),
  //       ),
  //     );
  //         }
  //         }
  //       }
  //       ),
  //     ),
  //   );
  //       }
  //       return;
  //     }

  //     await FirebaseFirestore.instance
  //     .collection('user')
  //     .doc(credential.user!.uid)
  //     .update({
  //       'isEmailVerified': true,
  //     });
  //     if(context.mounted){
  //       Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(builder: (context) => HomeScreen()), 
  //       (route) => false);
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     if (context.mounted) {
  //       String errorMessage;
  //       switch (e.code) {
  //         case 'user-not-found':
  //           errorMessage = 'Incorrect username or password. Try again';
  //           break;
  //         case 'wrong-password':
  //           errorMessage = 'Incorrect username or password. Try again';
  //           break;
  //         case 'invalid-email':
  //           errorMessage = 'Invalid email address';
  //           break;
  //         case 'user-disabled':
  //           errorMessage = 'This account has been disabled';
  //           break;
  //         case 'too-many-requests':
  //           errorMessage = 'Too many failed attempts. Please try again later.';
  //           break;
  //         default:
  //           errorMessage = 'Login failed: ${e.message}';
  //       }
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           backgroundColor: Color(0xFF2A2A2A),
  //           duration: Duration(seconds: 3),
  //           margin: EdgeInsets.all(20),
  //           behavior: SnackBarBehavior.floating,
  //           content: Text(
  //             errorMessage,
  //             style: TextStyles.white,
  //           ),
  //         ),
  //       );
  //     }
  //   }
  //   catch (e) {
  //     if(context.mounted){
  //        ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       backgroundColor: Color(0xFF2A2A2A),
  //       duration: Duration(seconds: 3),
  //       margin: EdgeInsets.all(20),
  //       behavior: SnackBarBehavior.floating,
  //       content: Text(
  //         'Login Failed: ${e.toString()}',
  //         style: TextStyles.white,
  //       ),
  //     ),
  //   );
  //     }
  //   } finally {
  //     isLoaded(false);
  //   }
  // }

  Future<void> pofileDetails({
    required UserDetails details,
    required BuildContext context,
  }) async {
    try {
      isLoaded(true);
      final user = FirebaseAuth.instance.currentUser;
      if(user == null) throw Exception('User not loged In');
      String? imageUrl;

      if(_profileImage != null){
        final ref = FirebaseStorage.instance
        .ref()
        .child('profile_images')
        .child('${user.uid}.jpg');

        await ref.putFile(_profileImage!);
        imageUrl = await ref.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('user').doc(user.uid).update({
        'name': details.name ?? '',
        'bio': details.bio ?? '',
        'profile': imageUrl ?? '',
      });

      if(context.mounted){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xFF2A2A2A),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Your account has been successfully created. Please log in to access the application',
          style: TextStyles.white,
        ),
      ),
    );
    }
    } catch (e) {
      if(context.mounted){
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Color(0xFF2A2A2A),
        duration: Duration(seconds: 3),
        margin: EdgeInsets.all(20),
        behavior: SnackBarBehavior.floating,
        content: Text(
          'Error: ${e.toString()}',
          style: TextStyles.white,
        ),
      ),
    );
      }
    } finally {
      isLoaded(false);
    }
  }

  Future<void> imagePicker(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);
    if(pickedFile != null){
      _profileImage = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future<void> showOptions({required BuildContext context})async{
    showModalBottomSheet(
      context: context, 
      builder: (context){
        return Container(
          height: 150,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            color: Color.fromARGB(255, 230, 229, 229),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                InkWell(
                  onTap: ()async{
                    Navigator.of(context).pop();
                    imagePicker(ImageSource.gallery);
                  },
                  splashColor: Colors.grey.shade300,
                  child: ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text(
                      'Gallery'
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    Navigator.of(context).pop();
                    imagePicker(ImageSource.camera);
                  },
                  splashColor: Colors.grey.shade300,
                  child: ListTile(
                    leading: Icon(Icons.add_a_photo),
                    title: Text(
                      'Camera'
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      });
  }
}