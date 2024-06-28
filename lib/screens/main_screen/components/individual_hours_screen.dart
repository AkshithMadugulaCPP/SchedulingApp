import 'package:flutter/material.dart';
import 'package:login_screen/screens/main_screen/components/view_schedule_screen.dart';
import '../models/business_model.dart';
import '../services/firestore_service.dart';
import 'add_individual_hours_screen.dart';
import 'add_member_screen.dart';

class IndividualHoursScreen extends StatefulWidget {
  final Business business;

  IndividualHoursScreen({required this.business});

  @override
  _IndividualHoursScreenState createState() => _IndividualHoursScreenState();
}

class _IndividualHoursScreenState extends State<IndividualHoursScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    Map<String, List<IndividualAvailability>> availabilityGroupedByDay = {};
    for (var availability in widget.business.individualAvailability) {
      if (availabilityGroupedByDay[availability.day] == null) {
        availabilityGroupedByDay[availability.day] = [];
      }
      availabilityGroupedByDay[availability.day]!.add(availability);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Individual Hours'),
      ),
      body: ListView.builder(
        itemCount: widget.business.members.length,
        itemBuilder: (context, index) {
          final member = widget.business.members[index];
          final memberAvailability = widget.business.individualAvailability
              .where((availability) => availability.memberId == member.userId)
              .toList();
          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ExpansionTile(
              title: Text(member.userId),
              children: memberAvailability.map((availability) {
                return ListTile(
                  title: Text('${availability.day}: ${availability.startTime} - ${availability.endTime}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddIndividualHoursScreen(
                                business: widget.business,
                                member: member,
                                existingAvailability: availability,
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
                          await _firestoreService.deleteIndividualHour(
                            widget.business.id,
                            availability.memberId,
                            day :availability.day,
                            startTime:availability.startTime,
                            endTime:availability.endTime,
                          );
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FloatingActionButton(
              heroTag: 'add_member',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMemberScreen(business: widget.business),
                  ),
                ).then((result) {
                  if (result == true) {
                    setState(() {});
                  }
                });
              },
              child: Icon(Icons.person_add),
            ),
            FloatingActionButton(
              heroTag: 'add_individual_hours',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddIndividualHoursScreen(business: widget.business),
                  ),
                ).then((result) {
                  if (result == true) {
                    setState(() {});
                  }
                });
              },
              child: Icon(Icons.add_alarm),
            ),
            FloatingActionButton(
              heroTag: 'generate_schedule',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewScheduleScreen(business: widget.business),
                  ),
                );
              },
              child: Icon(Icons.schedule),
            ),
          ],
        ),
      ),
    );
  }
}