import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:food_app/views/categories_page.dart';
import 'package:food_app/views/chatbot_page.dart';
import 'package:food_app/views/chat_screen_page.dart';
import 'package:food_app/views/home_page_category.dart';
import 'package:food_app/views/profile_page.dart';
import '../meal_suggestion_page.dart';
import '../services/auth/auth_services.dart';
import '../services/chat/chat_service.dart';
import 'chat_group_page.dart';
import 'group_chat_screen.dart';
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
      ChatbotPage(),

      HomePageCategory(),
      HomePage2(), // Sohbet sayfasını buraya ekleyin
      ProfilePage(),
    ];

    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        buttonBackgroundColor: Colors.white.withOpacity(0.1),
        color: const Color.fromARGB(255, 220, 220, 220),
        animationDuration: const Duration(milliseconds: 300),
        items:  <Widget>[
          Image.asset(
            'assets/icons/gemini_logo.png', // Resminizin yolu
            width: 30, // Genişlik ayarı (isteğe bağlı)
            height: 30, // Yükseklik ayarı (isteğe bağlı)
          ),

          Icon(
            Icons.home_filled,
            size: 30,
            color: Color.fromARGB(255, 120, 124, 236),
          ),
          Icon(
            Icons.chat,
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
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: _buildUserAndGroupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateGroupPage()), // GroupCreationPage sayfasına yönlendir
          );
        },
        child: const Icon(Icons.group_add),
        tooltip: "Grup Oluştur",
      ),
    );
  }

  Widget _buildUserAndGroupList() {
    return Column(
      children: [
        // Kullanıcı listesi
        Expanded(
          child: StreamBuilder(
            stream: _chatService.getUsersStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Error");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final userDataList = snapshot.data!;

              return ListView(
                children: userDataList.map<Widget>((userData) {
                  return _buildUserListItem(userData, context);
                }).toList(),
              );
            },
          ),
        ),
        // Grup listesi
        Expanded(
          child: StreamBuilder(
            stream: _chatService.getGroupsStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Error");
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final groupDataList = snapshot.data!;

              return ListView(
                children: groupDataList.map<Widget>((groupData) {
                  return _buildGroupListItem(groupData, context);
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }

  // Kullanıcı için bireysel bir liste öğesi oluştur
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()) {
      return UserTile(
        text: userData["email"],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                recieverEmail: userData["email"],
                receiverID: userData["uid"],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }

  // Grup için bireysel bir liste öğesi oluştur
  Widget _buildGroupListItem(Map<String, dynamic> groupData, BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.group),
      title: Text(groupData["name"]),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupChatScreen(
              groupId: groupData["id"],
              groupName: groupData["name"],
            ),
          ),
        );
      },
    );
  }
}
