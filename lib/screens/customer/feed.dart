import 'package:flutter/material.dart';

class Feed extends StatefulWidget {
  const Feed({super.key});

  @override
  State<Feed> createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DefaultTextStyle(
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 25.0,
          ),
          child: Text('Feed'),
        ),
        backgroundColor: Color(0xFF254EDB),
        elevation: 0.0,
      ),
      body: const Center(
        child: Text('Feed'),
      ),
    );
  }
}
