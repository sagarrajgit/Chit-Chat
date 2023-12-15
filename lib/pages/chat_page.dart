import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/my_text_field.dart';
import 'package:chatapp/service/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  const ChatPage({
    super.key,
    required this.receiverUserEmail,
    required this.receiverUserID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //Method
  void sendMessage() async {
    //only send message if there is something
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverUserID, _messageController.text);

      // clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[800],
        title: Text(widget.receiverUserEmail)
        ),
      body: Column(
        children: [
          // message
          Expanded(
            child: _buildMessageList(),
          ),

          // user input
          _buildMessageInput(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // build message list
  Widget _buildMessageList(){
    return StreamBuilder(
      stream: _chatService.getMessage(widget.receiverUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot){
        // error check
        if(snapshot.hasError){
          return Text('Error${snapshot.error}');
        }

        // if it's loading
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs.map((documrnt) => _buildMessageItem(documrnt)).toList(),
        );
      }
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document){
    Map<String, dynamic> data=document.data() as Map<String, dynamic>;

    // align the message to the right if the sender is the current user, o/w to the left
    var alignment=(data['senderId'] == _firebaseAuth.currentUser!.uid)? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Text(data['senderEmail']),
            const SizedBox(height: 5),
            ChatBubble(message: data['message']),
          ],
        ),
      )
    );
  }

  // build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        children: [
          // textfield
          Expanded(
            child: MyTextField(
              controller: _messageController,
              hintText: 'Enter Message',
              obscureText: false,
            ),
          ),
    
          // send button
          IconButton(
            onPressed: sendMessage,
            icon: const Icon(
              Icons.arrow_circle_right,
              color: Colors.black,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}
