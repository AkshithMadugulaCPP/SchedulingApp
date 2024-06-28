import 'package:flutter/material.dart';
import '../models/business_model.dart';
import '../services/firestore_service.dart';

class AddMemberScreen extends StatefulWidget {
  final Business business;

  AddMemberScreen({required this.business});

  @override
  _AddMemberScreenState createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Member'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final member = Member(
                      userId: _emailController.text, // Assuming email as userId for simplicity
                      role: 'member', // Default role
                    );
                    await _firestoreService.addMember(widget.business.id, member);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Member'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}