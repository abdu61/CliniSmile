import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dental_clinic/screens/staff/dynamic_pages/staff_chat_ui.dart';
import 'package:dental_clinic/shared/loading.dart';
import 'package:flutter/material.dart';

class StaffChatListUI extends StatefulWidget {
  @override
  _StaffChatListUIState createState() => _StaffChatListUIState();
}

class _StaffChatListUIState extends State<StaffChatListUI> {
  final chatRef = FirebaseFirestore.instance.collection('chats');
  final activeChatUserId = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: StreamBuilder<QuerySnapshot>(
              stream: chatRef.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error loading chats');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data!.docs[index];
                    var userId = doc.id.split('_').first;
                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .get(),
                      builder: (BuildContext context,
                          AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return const Text("Something went wrong");
                        }

                        if (snapshot.connectionState == ConnectionState.done) {
                          Map<String, dynamic> data =
                              snapshot.data!.data() as Map<String, dynamic>;
                          return ValueListenableBuilder<String>(
                            valueListenable: activeChatUserId,
                            builder: (context, value, child) {
                              return Container(
                                color:
                                    value == userId ? Colors.blue[100] : null,
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(8.0),
                                  title: Text('${data['name']}',
                                      style: const TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold)),
                                  onTap: () => activeChatUserId.value = userId,
                                  trailing: const Icon(
                                      Icons.arrow_forward_ios), // Add this line
                                ),
                              );
                            },
                          );
                        }

                        return const Loading();
                      },
                    );
                  },
                );
              },
            ),
          ),
          const VerticalDivider(width: 1.0),
          Expanded(
            flex: 3,
            child: ValueListenableBuilder<String>(
              valueListenable: activeChatUserId,
              builder: (context, value, child) {
                return value.isNotEmpty
                    ? StaffChatUI(userId: value)
                    : const Center(
                        child: Text('Select a chat to start messaging'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
