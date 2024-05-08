import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatUI extends StatefulWidget {
  final String userId;
  const ChatUI({Key? key, required this.userId}) : super(key: key);

  @override
  _ChatUIState createState() => _ChatUIState();
}

class _ChatUIState extends State<ChatUI> {
  final User user = FirebaseAuth.instance.currentUser!;
  final ChatUser chatUser =
      ChatUser(id: FirebaseAuth.instance.currentUser!.uid, firstName: "User");
  final ChatUser staffUser = ChatUser(id: "staffId", firstName: "Staff");
  final CollectionReference chatRef =
      FirebaseFirestore.instance.collection('chats');

  List<ChatMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: const Color.fromARGB(255, 220, 227, 255),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatRef
            .doc('${user.uid}_staffId')
            .collection('messages')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            messages = snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              return ChatMessage(
                user: data['sentBy'] == user.uid ? chatUser : staffUser,
                createdAt: (data['timestamp'] as Timestamp).toDate(),
                text: data['message'],
              );
            }).toList();
            return DashChat(
              currentUser: chatUser,
              onSend: _handleSubmitted,
              messages: messages,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _handleSubmitted(ChatMessage chatMessage) async {
    var chatDocRef = chatRef.doc('${user.uid}_staffId');
    var chatDoc = await chatDocRef.get();

    if (!chatDoc.exists) {
      await chatDocRef
          .set(<String, dynamic>{}); // create the document if it doesn't exist
    }

    await chatDocRef.collection('messages').add({
      'sentBy': user.uid,
      'message': chatMessage.text,
      'timestamp': Timestamp.fromDate(DateTime.now()),
    });
  }
}
