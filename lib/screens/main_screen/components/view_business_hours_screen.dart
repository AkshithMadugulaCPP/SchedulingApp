import 'package:flutter/material.dart';
import '../models/business_model.dart';
import '../services/firestore_service.dart';
import 'add_business_hours_screen.dart';

class ViewBusinessHoursScreen extends StatefulWidget {
  final Business business;

  ViewBusinessHoursScreen({required this.business});

  @override
  _ViewBusinessHoursScreenState createState() => _ViewBusinessHoursScreenState();
}

class _ViewBusinessHoursScreenState extends State<ViewBusinessHoursScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    Map<String, List<BusinessHour>> hoursGroupedByDay = {};
    for (var hour in widget.business.hours) {
      if (hoursGroupedByDay[hour.day] == null) {
        hoursGroupedByDay[hour.day] = [];
      }
      hoursGroupedByDay[hour.day]!.add(hour);
    }

    hoursGroupedByDay.forEach((day, hours) {
      hours.sort((a, b) {
        return _parseTimeToDateTime(a.startTime).compareTo(_parseTimeToDateTime(b.startTime));
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Business Hours'),
      ),
      body: ListView(
        children: hoursGroupedByDay.keys.map((day) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ExpansionTile(
              title: Text(day),
              children: hoursGroupedByDay[day]!.map((hour) {
                return ListTile(
                  title: Text('${hour.startTime} - ${hour.endTime}'),
                  subtitle: Text('People Required: ${hour.numOfPeopleRequired}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddBusinessHoursScreen(
                                business: widget.business,
                                existingHour: hour,
                              ),
                            ),
                          ).then((result) {
                            if (result == true) {
                              setState(() {});
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await _firestoreService.deleteBusinessHour(widget.business.id, hour);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBusinessHoursScreen(business: widget.business),
            ),
          ).then((result) {
            if (result == true) {
              setState(() {});
            }
          });
        },
        child: Icon(Icons.add_business),
      ),
    );
  }

  DateTime _parseTimeToDateTime(String time) {
    final timeParts = time.split(' ');
    final timeOfDayParts = timeParts[0].split(':');
    int hour = int.parse(timeOfDayParts[0]);
    final minute = int.parse(timeOfDayParts[1]);
    if (timeParts[1] == 'PM' && hour != 12) {
      hour += 12;
    }
    return DateTime(2022, 1, 1, hour, minute); // Using a dummy date
  }
}
