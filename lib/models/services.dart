import 'package:cloud_firestore/cloud_firestore.dart';

class Service {
  final String id;
  final String name;
  final double price;

  Service({
    this.id = '',
    required this.name,
    required this.price,
  });

  factory Service.fromFirestore(Map<String, dynamic> data) {
    return Service(
      name: data['name'] as String,
      price: (data['price'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
    };
  }
}
