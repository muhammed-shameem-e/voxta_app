import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voxta_app/Providers/Login_provider.dart';
import 'package:voxta_app/auth/create_acount_screen.dart';
import 'package:voxta_app/textStyles.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
                    'Welcome to Voxta',
                    style: TextStyles.wlcmvoxta,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Enter your Username & password to Continue.\n We will sent you a verification code',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: loginProvider.isSee ? true : false,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: GestureDetector(
                        onTap: () => loginProvider.makeItVisible(),
                        child: Icon(loginProvider.isSee ? Icons.visibility
                        :Icons.visibility_off),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide()
                      )
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return 'Enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF22C55E),
                      minimumSize: Size(320, 60),
                    ),
                    onPressed: ()async{
                      await loginProvider.loginWithUsername(
                        username: _usernameController.text.trim(), 
                        password: _passwordController.text.trim(), 
                        context: context);
                    }, 
                    child: loginProvider.isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text(
                      'Sign In',
                      style: TextStyles.nxtbtn,
                    )),
                    const SizedBox(height: 10),
                    ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF22C55E),
                      minimumSize: Size(320, 60),
                    ),
                    onPressed: (){
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => CreateAcountScreen())
                      );
                    }, 
                    child: Text(
                      'Create an Acount',
                      style: TextStyles.nxtbtn,
                    ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}