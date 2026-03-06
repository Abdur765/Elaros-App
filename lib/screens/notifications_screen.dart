import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/notification_viewmodel.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NotificationViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text("Notifications")),
      body: ListView.builder(
        itemCount: viewModel.notifications.length,
        itemBuilder: (context, index) {
          final notification = viewModel.notifications[index];

          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(notification.title),
              subtitle: Text(notification.message),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          viewModel.loadNotifications();
        },
        child: Icon(Icons.refresh),
      ),
    );
  }
}
