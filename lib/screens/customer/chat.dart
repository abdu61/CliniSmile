import 'dart:io';
import 'dart:typed_data';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final Gemini gemini = Gemini.instance;

  List<ChatMessage> messages = [];

  ChatUser user = ChatUser(id: "1", firstName: "Abdu", lastName: '');
  ChatUser geminiUser = ChatUser(
    id: "2",
    firstName: "Gemini",
  );

  @override
  Widget build(BuildContext context) {
    gemini
        .listModels()
        .then((models) => print(models))

        /// list
        .catchError((e) => print(e));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: const Color.fromARGB(255, 220, 227, 255),
      ),
      body: _buildUI(),
    );
  }

  Widget _buildUI() {
    return DashChat(
      currentUser: user,
      onSend: _handleSubmitted,
      messages: messages,
    );
  }

  void _handleSubmitted(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
    });
    try {
      String question = chatMessage.text;
      List<Uint8List>? images;
      if (chatMessage.medias?.isNotEmpty ?? false) {
        images = [
          File(chatMessage.medias!.first.url).readAsBytesSync(),
        ];
      }

      // Start a new conversation with the user's question

      gemini
          .streamGenerateContent(
        question,
        images: images,
      )
          .listen((event) {
        ChatMessage? lastMessage = messages.firstOrNull;
        if (lastMessage != null && lastMessage.user == geminiUser) {
          lastMessage = messages.removeAt(0);
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          lastMessage.text += response;
          setState(
            () {
              messages = [lastMessage!, ...messages];
            },
          );
        } else {
          String response = event.content?.parts?.fold(
                  "", (previous, current) => "$previous ${current.text}") ??
              "";
          ChatMessage message = ChatMessage(
            user: geminiUser,
            createdAt: DateTime.now(),
            text: response,
          );
          setState(() {
            messages = [message, ...messages];
          });
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
