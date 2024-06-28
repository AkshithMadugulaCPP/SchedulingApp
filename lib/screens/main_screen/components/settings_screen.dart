import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Center(
        child: Text(
          'Notification functionality will be implemented here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}