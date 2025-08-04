import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voxta_app/Providers/Login_provider.dart';
import 'package:voxta_app/auth/terms_conditons_screen.dart';
import 'package:voxta_app/auth/user_profile.dart';
import 'package:voxta_app/model_classes.dart/usermodel.dart';
import 'package:voxta_app/textStyles.dart';

class CreateAcountScreen extends StatelessWidget {
  CreateAcountScreen({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Create a Account',
                    style: TextStyles.wlcmvoxta,
                  ),
                  const SizedBox(height: 60),
                  TextFormField(
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'E-email',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Enter your e-mail';
                      }
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if(!emailRegex.hasMatch(value)){
                        return 'Please enter a valid e-mail address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _usernameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Create a Username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: loginProvider.isSee ? true : false,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: GestureDetector(
                        onTap: () => loginProvider.makeItVisible(),
                        child: Icon(
                          loginProvider.isSee ? Icons.visibility : Icons.visibility_off
                        ),
                      ),
                      prefixIcon: Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide()
                      ),
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Create a tough password';
                      }
                      if(value.length < 6){
                        return 'password should be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => loginProvider.isAccepted(),
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: loginProvider.isAccept ? Colors.green: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                          child: loginProvider.isAccept ? Icon(Icons.check,color: Colors.white,size: 15)
                          : Icon(Icons.check,color: Colors.white,size: 15),
                        )
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => TermsAndConditionScreen()),
                        ),
                        child: Text(
                          'Accept all terms & conditions',
                          style: TextStyles.acpttrms,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF22C55E),
                      minimumSize: Size(320, 60),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState!.validate() && loginProvider.isAccept){
                        final email = _emailController.text.trim();
                        final username = _usernameController.text.trim();
                        final password = _passwordController.text.trim();

                        final newUser = UserDetails(
                          email: email,
                          username: username,
                          password: password,
                          isEmailverified: false,
                        );

                        await loginProvider.registerUser(
                          details: newUser, 
                          context: context);
                        
                        _emailController.clear();
                        _usernameController.clear();
                        _passwordController.clear();
                        loginProvider.isAccepted();
                        if(context.mounted){
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => UserProfile())
                          );
                        }
                      }else{
                        loginProvider.remindAcceptTerms(context);
                      }
                    }, 
                    child: loginProvider.isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                      'Sign Up',
                      style: TextStyles.nxtbtn,
                    )
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}