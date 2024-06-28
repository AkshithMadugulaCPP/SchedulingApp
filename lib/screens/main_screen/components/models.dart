import 'package:flutter/material.dart';

class TimeSlot {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int peopleRequired;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.peopleRequired,
  });

  Map<String, dynamic> toJson() {
    return {
      'startTime': '${startTime.hour}:${startTime.minute}',
      'endTime': '${endTime.hour}:${endTime.minute}',
      'peopleRequired': peopleRequired,
    };
  }

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    final startTime = TimeOfDay(
      hour: int.parse(json['startTime'].split(":")[0]),
      minute: int.parse(json['startTime'].split(":")[1]),
    );
    final endTime = TimeOfDay(
      hour: int.parse(json['endTime'].split(":")[0]),
      minute: int.parse(json['endTime'].split(":")[1]),
    );
    return TimeSlot(
      startTime: startTime,
      endTime: endTime,
      peopleRequired: json['peopleRequired'],
    );
  }
}

class BusinessTiming {
  final String day;
  final List<TimeSlot> timeSlots;

  BusinessTiming({
    required this.day,
    required this.timeSlots,
  });

  Map<String, dynamic> toJson() {
    return {
      'day': day,
      'timeSlots': timeSlots.map((slot) => slot.toJson()).toList(),
    };
  }

  factory BusinessTiming.fromJson(Map<String, dynamic> json) {
    return BusinessTiming(
      day: json['day'],
      timeSlots: (json['timeSlots'] as List)
          .map((slotJson) => TimeSlot.fromJson(slotJson))
          .toList(),
    );
  }

  static List<BusinessTiming> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => BusinessTiming.fromJson(json)).toList();
  }
}

class IndividualAvailability {
  final String name;
  final Map<String, List<TimeSlot>> availability;

  IndividualAvailability({
    required this.name,
    required this.availability,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'availability': availability.map((key, value) => MapEntry(key, value.map((slot) => slot.toJson()).toList())),
    };
  }

  factory IndividualAvailability.fromJson(Map<String, dynamic> json) {
    return IndividualAvailability(
      name: json['name'],
      availability: (json['availability'] as Map<String, dynamic>).map((key, value) =>
          MapEntry(key, (value as List).map((slotJson) => TimeSlot.fromJson(slotJson)).toList())),
    );
  }

  static List<IndividualAvailability> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => IndividualAvailability.fromJson(json)).toList();
  }
}

class GeneratedSchedule {
  final String day;
  final List<Assignment> assignments;

  GeneratedSchedule({
    required this.day,
    required this.assignments,
  });

  Map<String, dynamic> toJson(BuildContext context) => {
    'day': day,
    'assignments': assignments.map((assignment) => assignment.toJson(context)).toList(),
  };

  factory GeneratedSchedule.fromJson(Map<String, dynamic> json) {
    return GeneratedSchedule(
      day: json['day'],
      assignments: (json['assignments'] as List).map((assignmentJson) => Assignment.fromJson(assignmentJson)).toList(),
    );
  }
}

class Assignment {
  final String person;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  Assignment({
    required this.person,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toJson(BuildContext context) => {
    'person': person,
    'startTime': startTime.format(context),
    'endTime': endTime.format(context),
  };

  factory Assignment.fromJson(Map<String, dynamic> json) {
    final startTime = TimeOfDay(
      hour: int.parse(json['startTime'].split(":")[0]),
      minute: int.parse(json['startTime'].split(":")[1]),
    );
    final endTime = TimeOfDay(
      hour: int.parse(json['endTime'].split(":")[0]),
      minute: int.parse(json['endTime'].split(":")[1]),
    );
    return Assignment(
      person: json['person'],
      startTime: startTime,
      endTime: endTime,
    );
  }
}