import 'package:flutter/material.dart';
import 'package:food_app/services/auth/auth_services.dart';
import 'package:food_app/services/chat/chat_service.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();
  final TextEditingController _groupNameController = TextEditingController();
  List<String> selectedUserIds = []; // Seçilen kullanıcıların uid'lerini tutacak

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Group")),
      body: Column(
        children: [
          TextField(
            controller: _groupNameController,
            decoration: InputDecoration(hintText: "Group Name"),
          ),
          Expanded(
            child: _buildUserList(),
          ),
          ElevatedButton(
            onPressed: () {
              createGroup();
            },
            child: Text("Create Group"),
          ),
        ],
      ),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatService.getUsersStream(), // Kullanıcı listesini al
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return ListView(
          children: snapshot.data!.map<Widget>((userData) {
            return CheckboxListTile(
              title: Text(userData["email"]),
              value: selectedUserIds.contains(userData["uid"]),
              onChanged: (bool? value) {
                setState(() {
                  if (value!) {
                    selectedUserIds.add(userData["uid"]);
                  } else {
                    selectedUserIds.remove(userData["uid"]);
                  }
                });
              },
            );
          }).toList(),
        );
      },
    );
  }

  void createGroup() {
    if (_groupNameController.text.isNotEmpty && selectedUserIds.isNotEmpty) {
      // Grup oluşturma işlevini çağır
      _chatService.createGroup(_groupNameController.text, selectedUserIds);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Grup oluşturuldu.")),
      );
      Navigator.pop(context); // Sayfayı kapat
    } else {
      // Uyarı ver
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter group name and select users.")),
      );
    }
  }
}
