import 'package:flutter/material.dart';
import '../models/business_model.dart';
import '../services/firestore_service.dart';

class AddBusinessScreen extends StatefulWidget {
  @override
  _AddBusinessScreenState createState() => _AddBusinessScreenState();
}

class _AddBusinessScreenState extends State<AddBusinessScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Business'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Business Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a business name';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _name = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final business = Business(
                      id: '', // Generate a unique ID
                      name: _name,
                      hours: [],
                      members: [],
                      adminId: '',
                      individualAvailability: [],
                    );
                    _firestoreService.addBusiness(business);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
