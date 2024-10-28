import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/my_button.dart';
import 'package:food_app/components/my_textfield.dart';
import 'package:food_app/views/home_page.dart';

import '../services/auth/auth_services.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();


  final void Function()? onTap;

// tap to go to register
  LoginScreen({super.key,  required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //logo
          Icon(
            Icons.message,
            size: 60,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(
            height: 50,
          ),
          Text("Hoşgeldiniz uygulamaya giriş yapın"),
          const SizedBox(
            height: 25,
          ),
          //email textfield
          MyTextfield(
            hintText: "Email",
            obsureText: false,
            controller: _emailController,
          ),
          const SizedBox(
            height: 10.0,
          ),
          MyTextfield(
            hintText: "Password",
            obsureText: true,
            controller: _pwController,
          ),
          const SizedBox(
            height: 25,
          ),
          //login button

          MyButton(
            text: "Oturum Aç",
            onTap:() =>login(context),
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Not a member? ",
                style: TextStyle(color: Colors.blue),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text("Register now",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),

            ],
          )
        ],
      ),
    );
  }

  Future<void> login(BuildContext context) async {
    //auth service
    final authService=AuthService();
    //try login
    try{
      await authService.signInWithEmailPassword(_emailController.text, _pwController.text);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
    }catch(e){
      showDialog(context: context, builder: (context)=>AlertDialog(
        title: Text(e.toString()),
      ));
    }


  }
}
