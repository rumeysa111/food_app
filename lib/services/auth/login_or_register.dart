import 'package:flutter/material.dart';
import 'package:food_app/views/login_screen.dart';
import 'package:food_app/views/register_screen.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  //initially, show login page
  bool showLoginPage=true;
  void togglePageShow(){
    setState(() {
      showLoginPage=!showLoginPage;

    });
  }
  @override
  Widget build(BuildContext context) {
   if(showLoginPage){
     return LoginScreen(
       onTap: togglePageShow,
     );
   }else{
     return RegisterScreen(
       onTap: togglePageShow,
     );
   }
  }
}
