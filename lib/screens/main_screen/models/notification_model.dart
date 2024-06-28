import 'package:cloud_firestore/cloud_firestore.dart';

class Notification {
  String notificationId;
  String userId;
  String message;
  Timestamp timestamp;
  bool read;

  Notification({
    required this.notificationId,
    required this.userId,
    required this.message,
    required this.timestamp,
    required this.read,
  });

  factory Notification.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Notification(
      notificationId: data['notificationId'] ?? '',
      userId: data['userId'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
      read: data['read'] ?? false,
    );
  }
}
