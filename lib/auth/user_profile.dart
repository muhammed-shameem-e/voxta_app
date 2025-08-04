import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:voxta_app/Providers/Login_provider.dart';
import 'package:voxta_app/auth/login_screen.dart';
import 'package:voxta_app/model_classes.dart/usermodel.dart';
import 'package:voxta_app/textStyles.dart';

class UserProfile extends StatelessWidget {
  UserProfile({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: (){
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
          Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen())
        );
            }, 
            child: Text(
              'Skip',
              style: TextStyles.blutxtbtn,
            ))
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Upload your profile image and complete\nthe remaining details(Optional).',
                  textAlign: TextAlign.center,
                  style: TextStyles.wightblk,
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () async {
                    await loginProvider.showOptions(context: context);
                  },
                  child: CircleAvatar(
                    radius: 100,
                    backgroundImage: loginProvider.profileImage != null 
                    ? FileImage(loginProvider.profileImage!) 
                    : null,
                    child: loginProvider.profileImage == null 
                    ? Icon(Icons.add_a_photo) 
                    : null,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),    
                const SizedBox(height: 10),
                TextFormField(
                  controller: _bioController,
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    prefixIcon: Icon(Icons.article),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide()
                    )
                  ),
                ),
                const SizedBox(height: 20),
                  ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF22C55E),
                    minimumSize: Size(320, 60),
                  ),
                  onPressed: ()async{
                    if(loginProvider.profileImage != null || _nameController.text.isNotEmpty || _bioController.text.isNotEmpty){

                      final details = UserDetails(
                        name: _nameController.text.trim(),
                        bio: _bioController.text.trim(),
                      );
                      await loginProvider.pofileDetails(
                        details: details, 
                        context: context);
                      
                      Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => LoginScreen())
                    );
                    }
                  }, 
                  child: loginProvider.isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                      'Proceed',
                      style: TextStyles.nxtbtn,
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}