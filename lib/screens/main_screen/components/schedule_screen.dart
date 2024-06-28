import 'package:flutter/material.dart';
import 'models.dart';

class ScheduleScreen extends StatelessWidget {
  final List<GeneratedSchedule> generatedSchedule;

  ScheduleScreen({required this.generatedSchedule});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Generated Schedule'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: generatedSchedule.length,
          itemBuilder: (context, index) {
            GeneratedSchedule schedule = generatedSchedule[index];
            return Card(
              child: Column(
                children: [
                  ListTile(
                    title: Text('${schedule.day}'),
                  ),
                  Column(
                    children: schedule.assignments.map((assignment) {
                      return ListTile(
                        title: Text('${assignment.person}'),
                        subtitle: Text('${assignment.startTime.format(context)} - ${assignment.endTime.format(context)}'),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
