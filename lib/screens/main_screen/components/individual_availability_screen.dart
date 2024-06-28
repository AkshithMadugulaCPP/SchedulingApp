import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';
import 'schedule_screen.dart';

class IndividualAvailabilityScreen extends StatefulWidget {
  @override
  _IndividualAvailabilityScreenState createState() => _IndividualAvailabilityScreenState();
}

class _IndividualAvailabilityScreenState extends State<IndividualAvailabilityScreen> {
  late SharedPreferences _prefs;
  final List<IndividualAvailability> _availabilities = [];
  final List<BusinessTiming> _businessTimings = [];
  List<GeneratedSchedule> _generatedSchedule = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      _availabilities.clear();
      _businessTimings.clear();
      _availabilities.addAll(IndividualAvailability.fromJsonList(json.decode(_prefs.getString('availabilities') ?? '[]')));
      _businessTimings.addAll(BusinessTiming.fromJsonList(json.decode(_prefs.getString('businessTimings') ?? '[]')));
    });
  }

  Future<void> _saveData() async {
    await _prefs.setString('availabilities', json.encode(_availabilities.map((availability) => availability.toJson()).toList()));
    await _prefs.setString('businessTimings', json.encode(_businessTimings.map((timing) => timing.toJson()).toList()));
  }

  void _addOrUpdateAvailability(String name, String day, TimeOfDay startTime, TimeOfDay endTime) {
    setState(() {
      int existingIndex = _availabilities.indexWhere((availability) => availability.name == name);

      if (existingIndex != -1) {
        if (_availabilities[existingIndex].availability.containsKey(day)) {
          _availabilities[existingIndex].availability[day]!.add(TimeSlot(startTime: startTime, endTime: endTime, peopleRequired: 1));
        } else {
          _availabilities[existingIndex].availability[day] = [TimeSlot(startTime: startTime, endTime: endTime, peopleRequired: 1)];
        }
      } else {
        _availabilities.add(IndividualAvailability(
          name: name,
          availability: {day: [TimeSlot(startTime: startTime, endTime: endTime, peopleRequired: 1)]},
        ));
      }
    });
    _saveData();
  }

  void _generateSchedule() {
    List<GeneratedSchedule> schedule = [];

    // Implement the scheduling logic here...

    // Iterate over each day of the week
    for (var day in ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']) {
      // Retrieve business timings for the current day
      var businessTiming = _businessTimings.firstWhere((timing) => timing.day == day, orElse: () => BusinessTiming(day: day, timeSlots: []));

      // Create a list to store assignments for the current day
      List<Assignment> assignments = [];

      // Iterate over each available person
      for (var availability in _availabilities) {
        // Check if the person is available on the current day
        if (availability.availability.containsKey(day)) {
          // Iterate over each time slot for the current person on the current day
          for (var timeSlot in availability.availability[day]!) {
            // Check if the time slot overlaps with any business timing
            var overlappingSlots = businessTiming.timeSlots.where((slot) => slot.startTime.hour <= timeSlot.endTime.hour && slot.endTime.hour >= timeSlot.startTime.hour);

            // If there are overlapping business timings, assign the person to the available time slot
            if (overlappingSlots.isNotEmpty) {
              // Calculate the total duration of the time slot
              var duration = timeSlot.endTime.hour - timeSlot.startTime.hour;

              // Assign the person to the time slot, considering breaks and maximum working hours
              // You need to implement this logic based on your requirements
              // For example, you could split the time slot into multiple assignments if needed
              // Ensure that each assignment adheres to the constraints

              // Add the assignment to the list of assignments for the current day
              assignments.add(Assignment(
                person: availability.name,
                startTime: timeSlot.startTime,
                endTime: timeSlot.endTime,
              ));
            }
          }
        }
      }

      // Create a GeneratedSchedule object for the current day and add it to the schedule
      schedule.add(GeneratedSchedule(day: day, assignments: assignments));
    }

    // Update the state with the generated schedule
    setState(() {
      _generatedSchedule = schedule;
    });

    // Navigate to the schedule screen and pass the generated schedule
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScheduleScreen(generatedSchedule: _generatedSchedule)),
    );
  }

  void _showAddAvailabilityDialog() {
    final TextEditingController nameController = TextEditingController();
    String selectedDay = 'Monday';
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Add Availability'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                  ),
                  DropdownButton<String>(
                    value: selectedDay,
                    onChanged: (newValue) {
                      setState(() {
                        selectedDay = newValue!;
                      });
                    },
                    items: <String>['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  ListTile(
                    title: Text('Start Time'),
                    trailing: startTime == null
                        ? Icon(Icons.access_time)
                        : Text(startTime!.format(context)),
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          startTime = pickedTime;
                        });
                      }
                    },
                  ),
                  ListTile(
                    title: Text('End Time'),
                    trailing: endTime == null
                        ? Icon(Icons.access_time)
                        : Text(endTime!.format(context)),
                    onTap: () async {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        setState(() {
                          endTime = pickedTime;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty && startTime != null && endTime != null) {
                      _addOrUpdateAvailability(
                        nameController.text,
                        selectedDay,
                        startTime!,
                        endTime!,
                      );
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget old_build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Individual Availability'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _availabilities.length,
                itemBuilder: (context, index) {
                  IndividualAvailability availability = _availabilities[index];
                  return Card(
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('${availability.name}'),
                        ),
                        Column(
                          children: availability.availability.entries.map((entry) {
                            return ListTile(
                              title: Text('${entry.key}: ${entry.value.map((slot) => '${slot.startTime.format(context)} - ${slot.endTime.format(context)}').join(', ')}'),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAvailabilityDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Set Individual Availability'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
        Expanded(
        child: ListView.builder(
        itemCount: _availabilities.length,
          itemBuilder: (context, index) {
            IndividualAvailability availability = _availabilities[index];
            return Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('${availability.name}'),
                  ),
                  Column(
                    children: availability.availability.entries.map((entry) {
                      return ListTile(
                        title: Text('${entry.key}: ${entry.value.map((slot) => '${slot.startTime.format(context)} - ${slot.endTime.format(context)}').join(', ')}'),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
            ElevatedButton(
              onPressed: _generateSchedule,
              child: Text('Generate Schedule'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddAvailabilityDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}