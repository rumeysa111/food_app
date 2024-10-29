import 'package:flutter/material.dart';
import 'package:food_app/services/chat/chat_service.dart';
import '../components/user_tile.dart';
import '../services/auth/auth_services.dart';
import 'chat_screen_page.dart';

class UserListScreen extends StatelessWidget {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text("Sohbet"),
      ),
      body: _buildUserList(),
    );
  }

  Widget _buildUserList() {
    return Column(
      children: [
        // Kullanıcı listesi için başlık
        Container(
          padding: const EdgeInsets.all(16.0),

          child: const Text(
            "Kullanıcılar",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        // Kullanıcı listesi
        Expanded(
          child: StreamBuilder(
            stream: _chatService.getUsersStream(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text("Hata oluştu");
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
      ],
    );
  }

  // Kullanıcı için bireysel bir liste öğesi oluştur
  Widget _buildUserListItem(Map<String, dynamic> userData, BuildContext context) {
    if (userData["email"] != _authService.getCurrentUser()) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        child: UserTile(
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
        ),
      );
    } else {
      return Container();
    }
  }
}
