import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:food_app/services/auth/auth_gate.dart';
import 'package:food_app/views/home_page.dart';
import 'package:food_app/views/landing_page.dart';
import 'package:food_app/views/login_screen.dart';
import 'package:provider/provider.dart';
import 'consts.dart';
import 'firebase_options.dart';

void main() async {


  Gemini.init(
    apiKey: GEMINI_API_KEY,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(

       MyApp(),

  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yemek Öneri Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home:  const LandingPage(),
    );
  }
}