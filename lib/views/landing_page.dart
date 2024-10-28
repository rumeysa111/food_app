import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_app/services/auth/login_or_register.dart';
import 'package:food_app/views/login_screen.dart';
import 'package:food_app/views/register_screen.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //arka plan resmi
          Positioned.fill(
            child: Image.asset(
              'assets/images/splash_screen.png',
              fit: BoxFit.cover,
            ),
          ),
          // buton
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LoginScreen(
                                  onTap: () {
                                    // Kayıt ekranına geçiş yap
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => RegisterScreen(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                              )), // RegisterScreen'ı burada tanımlayın
                                    );
                                  },
                                )));
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    backgroundColor: Color(0xFFFF9C00)
                  ),
                  child: const Text(

                    "Öğrenmeye Başla",
                    style: TextStyle(
                      fontSize: 24,color: Colors.white,
                      fontWeight:FontWeight.bold,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
