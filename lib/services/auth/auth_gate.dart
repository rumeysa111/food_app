import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_app/views/home_page.dart';
import 'package:food_app/views/landing_page.dart';
import 'package:food_app/views/splash_screen.dart';

import 'login_or_register.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context,snapshot){
            //user is logged in
            if(snapshot.hasData){
              return   SplashScreen();
            }
            //user is not logged in
            else{
              return const LoginOrRegister();
            }
          }),
    );
  }
}
