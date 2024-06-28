
import 'package:flutter/material.dart';

class BusinessTiming {
  final String day;
  final List<TimeSlot> timeSlots;

  BusinessTiming({required this.day, required this.timeSlots});

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'timeSlots': timeSlots.map((slot) => slot.toJson()).toList(),
    };
  }

  factory BusinessTiming.fromJson(Map<String, dynamic> json) {
    return BusinessTiming(
      day: json['day'],
      timeSlots: (json['timeSlots'] as List).map((slot) => TimeSlot.fromJson(slot)).toList(),
    );
  }

  static List<BusinessTiming> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => BusinessTiming.fromJson(json)).toList();
  }
}

class TimeSlot {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int peopleRequired;

  TimeSlot({required this.startTime, required this.endTime, required this.peopleRequired});

  Map<String, dynamic> toJson() {
    return {
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'peopleRequired': peopleRequired,
    };
  }

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      startTime: TimeOfDay(
        hour: int.parse(json['startTime'].split(':')[0]),
        minute: int.parse(json['startTime'].split(':')[1]),
      ),
      endTime: TimeOfDay(
        hour: int.parse(json['endTime'].split(':')[0]),
        minute: int.parse(json['endTime'].split(':')[1]),
      ),
      peopleRequired: json['peopleRequired'],
    );
  }
}

class IndividualAvailability {
  final String name;
  final Map<String, List<TimeSlot>> availability;

  IndividualAvailability({required this.name, required this.availability});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'availability': availability.map((key, value) => MapEntry(key, value.map((slot) => slot.toJson()).toList())),
    };
  }

  factory IndividualAvailability.fromJson(Map<String, dynamic> json) {
    return IndividualAvailability(
      name: json['name'],
      availability: Map<String, List<TimeSlot>>.from(json['availability'].map((key, value) {
        return MapEntry(key, (value as List).map((slot) => TimeSlot.fromJson(slot)).toList());
      })),
    );
  }

  static List<IndividualAvailability> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => IndividualAvailability.fromJson(json)).toList();
  }
}

class GeneratedSchedule {
  final String day;
  final List<ScheduleSlot> slots;

  GeneratedSchedule({required this.day, required this.slots});
}

class ScheduleSlot {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String person;

  ScheduleSlot({required this.startTime, required this.endTime, required this.person});
}