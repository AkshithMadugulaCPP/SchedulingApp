import 'package:flutter/material.dart';
import '../models/schedule.dart';

class ScheduleWidget extends StatelessWidget {
  final List<IndividualAvailability> availabilities;

  ScheduleWidget({required this.availabilities});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: availabilities.length,
      itemBuilder: (context, index) {
        IndividualAvailability availability = availabilities[index];
        return Card(
          child: ListTile(
            title: Text(availability.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: availability.availability.entries.map((entry) {
                return Text(
                  '${entry.key}: ${entry.value.map((slot) => '${slot.startTime.format(context)} - ${slot.endTime.format(context)}').join(', ')}',
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}