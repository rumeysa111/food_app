import 'package:cloud_firestore/cloud_firestore.dart';

class Messages{
  final String senderId;
  final String senderEmail;
  final String? receiverId;
  final String message;
  final Timestamp timestamp;
  final String? groupId;
  Messages({
    required this.senderId,
    required this.senderEmail,
    this.receiverId,
    required this.message,
    required this.timestamp,
    this.groupId,
});
  //convert to a map
Map<String,dynamic> toMap(){
  return{
    'senderId':senderId,
    'senderEmail':receiverId,
    'receiverId':receiverId,
    'message':message,
    'timestamp':timestamp,
    'groupId':groupId
  };
}

}