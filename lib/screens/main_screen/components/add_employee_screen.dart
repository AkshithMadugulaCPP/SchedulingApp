import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEmployeeScreen extends StatefulWidget {
  final String businessId;

  AddEmployeeScreen({required this.businessId});

  @override
  _AddEmployeeScreenState createState() => _AddEmployeeScreenState();
}

class _AddEmployeeScreenState extends State<AddEmployeeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  void _addEmployee() async {
    if (_formKey.currentState!.validate()) {
      String name = _nameController.text.trim();
      String email = _emailController.text.trim();

      DocumentReference userRef = await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'email': email,
        'role': 'employee',
        'businessId': widget.businessId,
      });

      await FirebaseFirestore.instance.collection('businesses').doc(widget.businessId).update({
        'employees': FieldValue.arrayUnion([userRef.id]),
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Employee")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),
                validator: (value) => value!.isEmpty ? "Please enter a name" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                validator: (value) => value!.isEmpty ? "Please enter an email" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addEmployee,
                child: Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
