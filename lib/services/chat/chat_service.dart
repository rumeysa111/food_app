import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_app/models/messages.dart';

class ChatService {
  //get instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //get user stream
  // Kullanıcıların stream'ini al
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      // Her belgeyi dolaşarak kullanıcı bilgilerini içeren bir liste döndür
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  //send message
  Future<void> sendMessage(String receiverID, message) async {
    //get current user info

    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();
    //create a new message
    Messages newMessage = Messages(
        senderId: currentUserId,
        senderEmail: currentUserEmail,
        receiverId: receiverID,
        message: message,

        timestamp: timestamp,
       );


    //construct chat room ıd gor the two users (sorted to ensure uniquenesss
    List<String> ids = [currentUserId, receiverID];
    ids.sort(); //sort the ids (this ensure the chatroom id is the same for any 2 peaople
    String chatRoomID = ids.join('_');

    //add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  //Grup oluşturma
  Future<void> createGroup(String groupName, List<String> users) async {
    // Yeni grup oluştur
    DocumentReference groupRef = await _firestore.collection('groups').add({
      'name': groupName,
      'members': users,
      'createdAt': FieldValue.serverTimestamp(),
    });

    // Her üye için grup kimliği altında bir kayıt oluştur
    for (String userId in users) {
      await _firestore.collection('users_groups').add({
        'userId': userId,
        'groupId': groupRef.id,
      });
    }
  }
  // Grup mesajlarını alma
  Stream<QuerySnapshot> getGroupMessages(String groupId) {
    return _firestore
        .collection("groups")
        .doc(groupId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // Kullanıcıların grup mesajlarını göndermesi
  Future<void> sendGroupMessage(String groupId, String message) async {
    final String currentUserId = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Yeni grup mesajı oluştur
    Messages newMessage = Messages(
      senderId: currentUserId,
      senderEmail: currentUserEmail,

      message: message,
      timestamp: timestamp,
    );


  }

  //get messages
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    //construct a chatroom ıd for the two users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomId)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
