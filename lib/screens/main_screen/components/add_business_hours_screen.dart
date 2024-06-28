import 'package:flutter/material.dart';
import '../models/business_model.dart';
import '../services/firestore_service.dart';

class AddBusinessHoursScreen extends StatefulWidget {
  final Business business;
  final BusinessHour? existingHour;

  AddBusinessHoursScreen({required this.business, this.existingHour});

  @override
  _AddBusinessHoursScreenState createState() => _AddBusinessHoursScreenState();
}

class _AddBusinessHoursScreenState extends State<AddBusinessHoursScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  late String _day;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  late int _numOfPeopleRequired;

  @override
  void initState() {
    super.initState();
    if (widget.existingHour != null) {
      _day = widget.existingHour!.day;
      _startTime = _parseTime(widget.existingHour!.startTime);
      _endTime = _parseTime(widget.existingHour!.endTime);
      _numOfPeopleRequired = widget.existingHour!.numOfPeopleRequired;
    } else {
      _day = 'Monday';
      _startTime = TimeOfDay.now();
      _endTime = TimeOfDay.now();
      _numOfPeopleRequired = 1;
    }
  }

  TimeOfDay _parseTime(String time) {
    final timeParts = time.split(' ');
    final timeOfDayParts = timeParts[0].split(':');
    int hour = int.parse(timeOfDayParts[0]);
    final minute = int.parse(timeOfDayParts[1]);
    if (timeParts[1] == 'PM' && hour != 12) {
      hour += 12;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime! : _endTime!,
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Business Hours'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _day,
                decoration: InputDecoration(labelText: 'Day'),
                items: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                    .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _day = value!;
                  });
                },
              ),
              ListTile(
                title: Text('Start Time'),
                subtitle: Text(_startTime?.format(context) ?? 'Select Time'),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context, true),
              ),
              ListTile(
                title: Text('End Time'),
                subtitle: Text(_endTime?.format(context) ?? 'Select Time'),
                trailing: Icon(Icons.access_time),
                onTap: () => _selectTime(context, false),
              ),
              TextFormField(
                initialValue: _numOfPeopleRequired.toString(),
                decoration: InputDecoration(labelText: 'Number of People Required'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _numOfPeopleRequired = int.parse(value!),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final businessHour = BusinessHour(
                      day: _day,
                      startTime: _startTime!.format(context),
                      endTime: _endTime!.format(context),
                      numOfPeopleRequired: _numOfPeopleRequired,
                    );
                    if (widget.existingHour != null) {
                      await _firestoreService.updateBusinessHour(widget.business.id, businessHour);
                    } else {
                      await _firestoreService.addBusinessHour(widget.business.id, businessHour);
                    }
                    Navigator.pop(context, true);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
