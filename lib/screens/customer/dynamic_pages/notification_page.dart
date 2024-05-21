import 'package:dental_clinic/shared/widgets/coreComponents/app_bar.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final int notificationCount = 0; // replace with your actual list length

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(title: 'Notifications'),
      body: notificationCount > 0
          ? ListView.builder(
              itemCount: notificationCount,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      'Notification $index'), // replace with your actual data
                  subtitle: Text(
                      'Details for notification $index'), // replace with your actual data
                );
              },
            )
          : Center(
              child: Text('No new notifications'),
            ),
    );
  }
}
