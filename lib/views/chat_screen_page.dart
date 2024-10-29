import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_app/components/chat_bubble.dart';
import 'package:food_app/components/my_textfield.dart';
import 'package:food_app/services/auth/auth_services.dart';
import 'package:food_app/services/chat/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String recieverEmail;
  final String receiverID;

  ChatScreen({super.key, required this.recieverEmail, required this.receiverID});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // Send message function
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.recieverEmail),
      backgroundColor: Colors.orange,),

      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(),
        ],
      ),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Error");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("loading...");
        }
        return ListView(
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      },
    );
  }

  // Build individual message item
  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    //is current user
    bool isCurrentUser= data['senderId' ]==_authService.getCurrentUser()!.uid;
    var alignment= isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;
    return Container(
      alignment: alignment,
        child: Column(
          crossAxisAlignment: isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
ChatBubble(message: data["message"], isCurrentUser: isCurrentUser)          ],
        ));
  }

  // Build user input
  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              label: "Mesaj Gönder",
              hintText: "Mesaj yazınız",
              obsureText: false,
              controller: _messageController,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              shape: BoxShape.circle
            ),
            margin:  const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: Icon(Icons.arrow_upward),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
