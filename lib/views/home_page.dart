import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_app/views/chatbot_page.dart';
import 'package:food_app/views/maps.dart';
import 'package:food_app/views/profile_page.dart';
import 'package:food_app/views/question_page.dart';
import 'package:food_app/views/random_page.dart';

import '../meal_suggestion_page.dart';
import 'landing_page.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
ChatbotPage(),
      MealSuggestionPage(),
      LandingPage(),

      RandomPage(),
     // Maps(),
      ProfilePage(),



    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex, // Güncel indeks burada kullanılıyor
        buttonBackgroundColor: Colors.white.withOpacity(0.1),
        color: const Color.fromARGB(255, 220, 220, 220),
        animationDuration: const Duration(milliseconds: 300),
        items: const <Widget>[
         // Takvim ikonu
          // Ekip ikonu
          Icon(
            Icons.chat,
            size: 30,
            color: Color.fromARGB(255, 120, 124, 236),
          ),
          // Sohbet ikonu
          Icon(
            Icons.shuffle,
            size: 30,
            color: Color.fromARGB(255, 120, 124, 236),
          ),
          Icon(
            Icons.home_filled,
            size: 30,
            color: Color.fromARGB(255, 120, 124, 236),
          ),

          Icon(
            Icons.map_rounded,
            size: 30,
            color: Color.fromARGB(255, 120, 124, 236),
          ),
          Icon(
            Icons.supervised_user_circle_rounded,
            size: 30,
            color: Color.fromARGB(255, 120, 124, 236),
          ),

        ],
        onTap: _onItemTapped,
        backgroundColor:
        const Color.fromARGB(255, 255, 255, 255), // Arka plan rengi
      ),
    );
  }
}