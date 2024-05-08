import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash_chat_2/dash_chat_2.dart';

class StaffChatUI extends StatefulWidget {
  final String userId;
  const StaffChatUI({Key? key, required this.userId}) : super(key: key);

  @override
  _StaffChatUIState createState() => _StaffChatUIState();
}

class _StaffChatUIState extends State<StaffChatUI> {
  final User user = FirebaseAuth.instance.currentUser!;
  final ChatUser chatUser =
      ChatUser(id: FirebaseAuth.instance.currentUser!.uid, firstName: "Staff");
  final ChatUser staffUser = ChatUser(id: "staffId", firstName: "User");
  final CollectionReference chatRef =
      FirebaseFirestore.instance.collection('chats');

  List<ChatMessage> messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with user ${widget.userId}'),
        backgroundColor: const Color.fromARGB(255, 192, 192, 192),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: chatRef
            .doc('${widget.userId}_staffId')
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
    var chatDocRef = chatRef.doc('${widget.userId}_staffId');
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
