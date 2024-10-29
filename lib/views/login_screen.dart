import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/my_button.dart';
import 'package:food_app/components/my_textfield.dart';
import 'package:food_app/views/home_page.dart';

import '../services/auth/auth_services.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();


  final void Function()? onTap;

// tap to go to register
  LoginScreen({super.key,  required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100], // Açık turuncu arka plan
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Hoşgeldiniz!",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 30),
          //email textfield
          MyTextfield(
            label: "E posta",
            hintText: "E postanızı giriniz",
            obsureText: false,
            controller: _emailController,
          ),
          const SizedBox(
            height: 25.0,
          ),
          MyTextfield(
            label: "Şifre",
            hintText: "Şifreyi giriniz",
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
          const SizedBox(height: 25),
          // Google ile Giriş Yap Butonu
          ElevatedButton.icon(
            icon: Image.asset('assets/images/google_logo.png',height: 24,),
            label: Text("Google ile Giriş Yap",style: TextStyle(color: Colors.black),),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            onPressed: () async {
              final user = await _googleSignInProvider.signInWithGoogle();
              if (user != null) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("Giriş Başarısız"),
                    content: Text("Google ile giriş yapılamadı."),
                  ),
                );
              }
            },
          ),
          const SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Üye değil misin ? ",
                style: TextStyle(color: Colors.black),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text("Kayıt Ol",
                  style:TextStyle(
                    color:Colors.blueAccent ,
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
