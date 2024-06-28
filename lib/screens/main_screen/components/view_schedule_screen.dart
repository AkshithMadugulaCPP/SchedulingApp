import 'package:flutter/material.dart';
import '../models/business_model.dart';
import '../services/firestore_service.dart';

class ViewScheduleScreen extends StatefulWidget {
  final Business business;

  ViewScheduleScreen({required this.business});

  @override
  _ViewScheduleScreenState createState() => _ViewScheduleScreenState();
}

class _ViewScheduleScreenState extends State<ViewScheduleScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  Map<String, Map<String, List<ShiftSchedule>>> schedule = {};

  @override
  void initState() {
    super.initState();
    _generateSchedule();
  }

  void _generateSchedule() {
    Map<String, Map<String, List<ShiftSchedule>>> newSchedule = {};

    for (var businessHour in widget.business.hours) {
      final day = businessHour.day;
      final shiftTime = '${businessHour.startTime} - ${businessHour.endTime} - people needed ${businessHour.numOfPeopleRequired}';

      if (newSchedule[day] == null) {
        newSchedule[day] = {};
      }

      if (newSchedule[day]![shiftTime] == null) {
        newSchedule[day]![shiftTime] = [];
      }

      List<Member> availableMembers = widget.business.members.where((member) {
        return widget.business.individualAvailability.any((availability) {
          return availability.memberId == member.userId &&
              availability.day == day &&
              _isTimeOverlap(availability.startTime, availability.endTime, businessHour.startTime, businessHour.endTime);
        });
      }).toList();

      int requiredPeople = businessHour.numOfPeopleRequired;

      for (var member in availableMembers) {
        if (requiredPeople == 0) break;
        newSchedule[day]![shiftTime]!.add(ShiftSchedule(
          member: member,
          startTime: businessHour.startTime,
          endTime: businessHour.endTime,
        ));
        requiredPeople--;
      }
    }

    setState(() {
      schedule = newSchedule;
    });

    // Save the schedule to Firebase
    _firestoreService.saveSchedule(widget.business.id, newSchedule);
  }

  bool _isTimeOverlap(String start1, String end1, String start2, String end2) {
    DateTime startTime1 = _parseTimeToDateTime(start1);
    DateTime endTime1 = _parseTimeToDateTime(end1);
    DateTime startTime2 = _parseTimeToDateTime(start2);
    DateTime endTime2 = _parseTimeToDateTime(end2);

    return startTime1.isBefore(endTime2) && startTime2.isBefore(endTime1);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Schedule'),
      ),
      body: ListView(
        children: schedule.keys.map((day) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ExpansionTile(
              title: Text(day),
              children: schedule[day]!.keys.map((shiftTime) {
                return ExpansionTile(
                  title: Text(shiftTime),
                  children: schedule[day]![shiftTime]!.map((shift) {
                    return ListTile(
                      title: Text('${shift.startTime} - ${shift.endTime}'),
                      subtitle: Text('Assigned to: ${shift.member.userId}'),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ShiftSchedule {
  final Member member;
  final String startTime;
  final String endTime;

  ShiftSchedule({
    required this.member,
    required this.startTime,
    required this.endTime,
  });
}
