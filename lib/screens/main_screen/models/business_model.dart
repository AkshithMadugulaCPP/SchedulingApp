import 'package:cloud_firestore/cloud_firestore.dart';

class Business {
  final String id;
  final String name;
  final String adminId; // Ensure this is included
  final List<BusinessHour> hours;
  final List<Member> members;
  final List<IndividualAvailability> individualAvailability;

  Business({
    required this.id,
    required this.name,
    required this.adminId, // Ensure this is included
    required this.hours,
    required this.members,
    required this.individualAvailability,
  });

  factory Business.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Business(
      id: doc.id,
      name: data['name'] ?? '',
      adminId: data['adminId'] ?? '', // Ensure this is included
      hours: (data['hours'] as List).map((hour) => BusinessHour.fromMap(hour)).toList(),
      members: (data['members'] as List).map((member) => Member.fromMap(member)).toList(),
      individualAvailability: (data['individualAvailability'] as List).map((availability) => IndividualAvailability.fromMap(availability)).toList(), // Ensure this is included
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'adminId': adminId, // Ensure this is included
      'hours': hours.map((hour) => hour.toMap()).toList(),
      'members': members.map((member) => member.toMap()).toList(),
      'individualAvailability': individualAvailability.map((availability) => availability.toMap()).toList(), // Ensure this is included
    };
  }
}

class IndividualAvailability {
  final String memberId;
  final String day;
  final String startTime;
  final String endTime;

  IndividualAvailability({
    required this.memberId,
    required this.day,
    required this.startTime,
    required this.endTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'memberId': memberId,
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
    };
  }

  factory IndividualAvailability.fromMap(Map<String, dynamic> data) {
    return IndividualAvailability(
      memberId: data['memberId'] ?? '',
      day: data['day'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
    );
  }
}

class Hour {
  String day;
  String startTime;
  String endTime;
  int numOfPeopleRequired;

  Hour({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.numOfPeopleRequired,
  });

  factory Hour.fromMap(Map<String, dynamic> data) {
    return Hour(
      day: data['day'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      numOfPeopleRequired: data['numOfPeopleRequired'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'numOfPeopleRequired': numOfPeopleRequired,
    };
  }

  BusinessHour toBusinessHour() {
    return BusinessHour(
      day: day,
      startTime: startTime,
      endTime: endTime,
      numOfPeopleRequired: numOfPeopleRequired,
    );
  }
}

class BusinessHour {
  final String day;
  final String startTime;
  final String endTime;
  final int numOfPeopleRequired;

  BusinessHour({
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.numOfPeopleRequired,
  });

  Map<String, dynamic> toMap() {
    return {
      'day': day,
      'startTime': startTime,
      'endTime': endTime,
      'numOfPeopleRequired': numOfPeopleRequired,
    };
  }

  factory BusinessHour.fromMap(Map<String, dynamic> data) {
    return BusinessHour(
      day: data['day'] ?? '',
      startTime: data['startTime'] ?? '',
      endTime: data['endTime'] ?? '',
      numOfPeopleRequired: data['numOfPeopleRequired'] ?? 0,
    );
  }

  factory BusinessHour.fromHour(Hour hour) {
    return BusinessHour(
      day: hour.day,
      startTime: hour.startTime,
      endTime: hour.endTime,
      numOfPeopleRequired: hour.numOfPeopleRequired,
    );
  }
}

class Member {
  final String userId;
  final String role;
  final String? availability; // Add this field

  Member({required this.userId, required this.role, this.availability}); // Update constructor

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'role': role,
      'availability': availability,
    };
  }

  static Member fromMap(Map<String, dynamic> map) {
    return Member(
      userId: map['userId'] ?? '',
      role: map['role'] ?? '',
      availability: map['availability'], // Update this
    );
  }
}
