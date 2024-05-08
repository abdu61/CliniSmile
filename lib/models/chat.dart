import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String message;
  final String sentBy;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.message,
    required this.sentBy,
    required this.timestamp,
  });

  // Method to convert Firestore document to ChatMessage object
  factory ChatMessage.fromDocument(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      message: data['message'],
      sentBy: data['sentBy'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Method to convert ChatMessage object to JSON
  Map<String, dynamic> toDocument() {
    return {
      'message': message,
      'sentBy': sentBy,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
