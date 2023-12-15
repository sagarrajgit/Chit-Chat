import 'package:chatapp/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatService extends ChangeNotifier {
  
  // get instance of auth and firestore
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore=FirebaseFirestore.instance;

   // SEND MESSAGE
   Future<void> sendMessage(String receiverId, String message) async{
    //get current user info
    final String currentUserId=_firebaseAuth.currentUser!.uid;
    final String currentUserEmail=_firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp=Timestamp.now();

    //create a new message
    Message newMessage=Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      message: message,
      timestamp: timestamp,
    );

    //construct chat room id from current user id and receiver id
    List<String> ids = [currentUserId, receiverId];
    ids.sort(); // sorting the ids ensure the chat room id is always same for any pair of user 
    String chatRoomId=ids.join("_"); // combine the ids into a single use as a chatroomID 

    //add new message to database
    await _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').add(newMessage.toMap());
   }

   // GET MESSAGE
   Stream<QuerySnapshot> getMessage(String userId, String otherUserId){
    // construct chat room id from user ids
    List<String> ids=[userId, otherUserId];
    ids.sort();
    String chatRoomId=ids.join("_");

    return _firestore.collection('chat_rooms').doc(chatRoomId).collection('messages').orderBy('timestamp', descending: false).snapshots();
   }
}