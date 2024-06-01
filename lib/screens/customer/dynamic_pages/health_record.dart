import 'package:dental_clinic/models/health.dart';
import 'package:dental_clinic/services/database.dart';
import 'package:dental_clinic/shared/widgets/coreComponents/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HealthRecordPage extends StatelessWidget {
  final String userId;
  final DatabaseService database;

  HealthRecordPage({required this.userId})
      : database = DatabaseService(uid: userId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: 'Health Record'),
      body: StreamBuilder<QuerySnapshot>(
        stream: database.getHealthRecordsByUserId(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final records = snapshot.data!.docs
                .map((doc) => HealthRecord.fromDocument(doc))
                .toList();
            return records.isNotEmpty
                ? ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return ListTile(
                        title: Text(record.details),
                        subtitle: Text(record.date.toString()),
                      );
                    },
                  )
                : const Center(child: Text('No health records'));
          }
        },
      ),
    );
  }
}
