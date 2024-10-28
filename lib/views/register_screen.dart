import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth/auth_services.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final void Function()? onTap;

   RegisterScreen({super.key, this.onTap});

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
          Text("Uygulamamıza kayıt olun."),
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
            height: 10,
          ),
          MyTextfield(
            hintText: " Confirm Password",
            obsureText: true,
            controller: _confirmPwController,
          ),
          const SizedBox(
            height: 25.0,
          ),
          //login button

          MyButton(
            text: "Kayıt Ol",

          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Zaten hesabın var mı? ",
                style: TextStyle(color: Colors.blue),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text("Login now",
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

  void register(BuildContext context) {
    final _auth=AuthService();
    //password match create user

    if(_pwController.text==_emailController.text){
      try{
        _auth.signUpWithEmailPassword(_emailController.text, _pwController.text);

      }catch(e){
        showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text(e.toString()),
        ));
      }
    }
    //passwords dont match_> tell user to fix
    else{
      showDialog(context: context, builder: (context)=>AlertDialog(title: Text("Passwords dont match"),));
    }



  }
}
