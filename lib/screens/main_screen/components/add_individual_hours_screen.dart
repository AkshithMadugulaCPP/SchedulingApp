import 'package:flutter/material.dart';
import '../models/business_model.dart';
import '../services/firestore_service.dart';

class AddIndividualHoursScreen extends StatefulWidget {
  final Business business;
  final IndividualAvailability? existingAvailability;
  final Member? member;

  AddIndividualHoursScreen({
    required this.business,
    this.existingAvailability,
    this.member,
  });

  @override
  _AddIndividualHoursScreenState createState() => _AddIndividualHoursScreenState();
}

class _AddIndividualHoursScreenState extends State<AddIndividualHoursScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  String? selectedMemberId;
  late String _day;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  @override
  void initState() {
    super.initState();
    if (widget.existingAvailability != null) {
      selectedMemberId = widget.existingAvailability!.memberId;
      _day = widget.existingAvailability!.day;
      _startTime = _parseTime(widget.existingAvailability!.startTime);
      _endTime = _parseTime(widget.existingAvailability!.endTime);
    } else {
      selectedMemberId = widget.member?.userId;
      _day = 'Monday';
      _startTime = TimeOfDay.now();
      _endTime = TimeOfDay.now();
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
        title: Text('Add Individual Availability'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: selectedMemberId,
                decoration: InputDecoration(labelText: 'Member'),
                items: widget.business.members.map((member) {
                  return DropdownMenuItem(
                    value: member.userId,
                    child: Text(member.userId),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedMemberId = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a member' : null,
              ),
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final availability = IndividualAvailability(
                      memberId: selectedMemberId!,
                      day: _day,
                      startTime: _startTime!.format(context),
                      endTime: _endTime!.format(context),
                    );
                    if (widget.existingAvailability != null) {
                      await _firestoreService.updateIndividualHour(widget.business.id, availability);
                    } else {
                      await _firestoreService.addIndividualHour(widget.business.id, availability);
                    }
                    Navigator.pop(context);
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
