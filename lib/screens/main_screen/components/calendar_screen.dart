import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendar'),
      ),
      body: Center(
        child: Text(
          'Calendar functionality will be implemented here.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}