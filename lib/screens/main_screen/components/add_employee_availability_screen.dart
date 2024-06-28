import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEmployeeAvailabilityScreen extends StatefulWidget {
  final String userId;

  AddEmployeeAvailabilityScreen({required this.userId});

  @override
  _AddEmployeeAvailabilityScreenState createState() => _AddEmployeeAvailabilityScreenState();
}

class _AddEmployeeAvailabilityScreenState extends State<AddEmployeeAvailabilityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();

  void _addAvailability() async {
    if (_formKey.currentState!.validate()) {
      String day = _dayController.text.trim();
      String startTime = _startTimeController.text.trim();
      String endTime = _endTimeController.text.trim();

      await FirebaseFirestore.instance.collection('availability').doc(widget.userId).set({
        'availability': FieldValue.arrayUnion([{
          'day': day,
          'startTime': startTime,
          'endTime': endTime,
        }]),
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Availability")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _dayController,
                decoration: InputDecoration(labelText: "Day"),
                validator: (value) => value!.isEmpty ? "Please enter a day" : null,
              ),
              TextFormField(
                controller: _startTimeController,
                decoration: InputDecoration(labelText: "Start Time"),
                validator: (value) => value!.isEmpty ? "Please enter start time" : null,
              ),
              TextFormField(
                controller: _endTimeController,
                decoration: InputDecoration(labelText: "End Time"),
                validator: (value) => value!.isEmpty ? "Please enter end time" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addAvailability,
                child: Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
