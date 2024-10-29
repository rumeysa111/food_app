import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../components/my_button.dart';
import '../components/my_textfield.dart';
import '../services/auth/auth_services.dart';
import 'home_page.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _confirmPwController = TextEditingController();
  final GoogleSignInProvider _googleSignInProvider = GoogleSignInProvider();

  final void Function()? onTap;

   RegisterScreen({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          const SizedBox(
            height: 50,
          ),
          Text(
            "Hesap Oluşturun",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(
            height: 50,
          ),

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
            hintText: "Şİfre",
            obsureText: true,
            controller: _pwController,
          ),
          const SizedBox(
            height: 25,
          ),
          MyTextfield(
            label: "Şifre Tekrarı",
            hintText: " Şifreyi Tekrar giriniz",
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
              Text("Zaten hesabın var mı? ",
                style: TextStyle(color: Colors.black87),
              ),
              GestureDetector(
                onTap: onTap,
                child: Text("Login now",
                  style: TextStyle(
                    color: Colors.blueAccent,
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
