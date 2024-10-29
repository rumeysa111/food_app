import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_app/views/chatbot_page.dart';
import 'package:food_app/views/chat_screen_page.dart';
import 'package:food_app/views/home_page_category.dart';
import 'package:food_app/views/profile_page.dart';
import 'package:food_app/views/user_list_screen.dart';
import '../meal_suggestion_page.dart';
import '../services/auth/auth_services.dart';
import '../services/chat/chat_service.dart';

import 'landing_page.dart';
import '../components/user_tile.dart';
import 'package:rxdart/rxdart.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  void logout() {
    final _auth = AuthService();
    _auth.signOut();
  }

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


      HomePageCategory(),
      HomePage2(), // Sohbet sayfasını buraya ekleyin
      ChatbotPage(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        buttonBackgroundColor: Colors.white.withOpacity(0.1),
        color: const Color.fromARGB(255, 255, 244, 230), // Pastel krem-turuncu ton
        animationDuration: const Duration(milliseconds: 300),
        items:  <Widget>[


          Icon(
            Icons.home_filled,
            size: 30,
              color: Colors.orange          ),
          Icon(
            Icons.chat,
            size: 30,
              color: Colors.orange          ),
          Image.asset(
            'assets/icons/gemini_logo.png', // Resminizin yolu
            width: 30, // Genişlik ayarı (isteğe bağlı)
            height: 30, // Yükseklik ayarı (isteğe bağlı)
          ),
          Icon(
            Icons.supervised_user_circle_rounded,
            size: 30,
            color: Colors.orange
          ),
        ],
        onTap: _onItemTapped,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}

class HomePage2 extends StatelessWidget {
  HomePage2({super.key});

  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: UserListScreen(),
    );
  }





}
