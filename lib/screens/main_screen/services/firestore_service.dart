import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/view_schedule_screen.dart';
import '../models/business_model.dart';
import '../models/notification_model.dart';


class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Business>> getBusinesses() async {
    final snapshot = await _db.collection('businesses').get();
    return snapshot.docs.map((doc) => Business.fromFirestore(doc)).toList();
  }

  Future<void> addMember(String businessId, Member member) async {
    final doc = _db.collection('businesses').doc(businessId);
    await doc.update({
      'members': FieldValue.arrayUnion([member.toMap()]),
    });
  }

  Future<Business?> getBusinessById(String businessId) async {
    final doc = await _db.collection('businesses').doc(businessId).get();
    return doc.exists ? Business.fromFirestore(doc) : null;
  }

  Future<void> addBusiness(Business business) async {
    DocumentReference docRef = await _db.collection('businesses').add(business.toMap());
    await docRef.update({'id': docRef.id}); // Set the id field in the document
  }

  Future<void> deleteBusiness(String businessId) async {
    await _db.collection('businesses').doc(businessId).delete();
  }

  Future<void> addBusinessHour(String businessId, BusinessHour hour) async {
    await _db.collection('businesses').doc(businessId).update({
      'hours': FieldValue.arrayUnion([hour.toMap()]),
    });
  }

  Future<void> deleteBusinessHour(String businessId, BusinessHour hourToDelete) async {
    // Retrieve the existing business document
    DocumentSnapshot businessSnapshot = await FirebaseFirestore.instance.collection('businesses').doc(businessId).get();
    if (!businessSnapshot.exists) return;

    // Get the current business data
    Map<String, dynamic> businessData = businessSnapshot.data() as Map<String, dynamic>;
    List<dynamic> currentHours = businessData['hours'] ?? [];

    // Remove the specific hour
    List<dynamic> updatedHours = currentHours.where((hour) {
      return !(hour['day'] == hourToDelete.day && hour['startTime'] == hourToDelete.startTime && hour['endTime'] == hourToDelete.endTime);
    }).toList();

    // Update the business document with the new hours
    await FirebaseFirestore.instance.collection('businesses').doc(businessId).update({
      'hours': updatedHours,
    });
  }

  Future<void> updateBusinessHour(String businessId, BusinessHour updatedHour) async {
    // Retrieve the existing business document
    DocumentSnapshot businessSnapshot = await FirebaseFirestore.instance.collection('businesses').doc(businessId).get();
    if (!businessSnapshot.exists) return;

    // Get the current business data
    Map<String, dynamic> businessData = businessSnapshot.data() as Map<String, dynamic>;
    List<dynamic> currentHours = businessData['hours'] ?? [];

    // Find and update the specific hour
    List<dynamic> updatedHours = currentHours.map((hour) {
      if (hour['day'] == updatedHour.day && hour['startTime'] == updatedHour.startTime && hour['endTime'] == updatedHour.endTime) {
        return updatedHour.toMap();
      }
      return hour;
    }).toList();

    // Update the business document with the new hours
    await FirebaseFirestore.instance.collection('businesses').doc(businessId).update({
      'hours': updatedHours,
    });
  }

  Future<void> addIndividualHour(String businessId, IndividualAvailability availability) async {
    await _db.collection('businesses').doc(businessId).update({
      'individualAvailability': FieldValue.arrayUnion([availability.toMap()]),
    });
  }

  Future<void> addIndividualAvailability(String businessId, IndividualAvailability availability) async {
    await _db
        .collection('businesses')
        .doc(businessId)
        .update({
      'individualAvailability': FieldValue.arrayUnion([availability.toMap()])
    });
  }

  Future<void> updateIndividualHour(String businessId, IndividualAvailability availability) async {
    final businessDoc = await _db.collection('businesses').doc(businessId).get();
    final businessData = businessDoc.data()!;
    final individualAvailability = (businessData['individualAvailability'] as List)
        .where((avail) => avail['memberId'] != availability.memberId)
        .toList();
    individualAvailability.add(availability.toMap());
    await _db.collection('businesses').doc(businessId).update({
      'individualAvailability': individualAvailability,
    });
  }

  Future<void> updateIndividualAvailability(String businessId, IndividualAvailability availability) async {
    final doc = _db.collection('businesses').doc(businessId);
    final business = await getBusinessById(businessId);
    final updatedAvailability = business!.individualAvailability.map((a) {
      if (a.memberId == availability.memberId && a.day == availability.day) {
        return availability.toMap();
      } else {
        return a.toMap();
      }
    }).toList();
    await doc.update({'individualAvailability': updatedAvailability});
  }

  Future<void> deleteIndividualHour(String businessId, String memberId,
      {String day = "", String startTime = "", String endTime = ""}) async {
    final businessDoc = await _db.collection('businesses').doc(businessId).get();
    final businessData = businessDoc.data()!;
    final individualAvailability = (businessData['individualAvailability'] as List)
        .where((availability) => availability['memberId'] != memberId)
        .toList();
    await _db.collection('businesses').doc(businessId).update({
      'individualAvailability': individualAvailability,
    });
  }

  Future<void> updateBusinessMembers(String businessId, List<Member> members) async {
    await _db.collection('businesses').doc(businessId).update({
      'members': members.map((m) => m.toMap()).toList(),
    });
  }

  Future<List<Business>> getUserBusinesses(String userId) async {
    final userDoc = await _db.collection('users').doc(userId).get();
    final userBusinesses = (userDoc.data()?['businesses'] as List<dynamic>).map((item) => item['businessId']).toList();

    final querySnapshot = await _db.collection('businesses').where(FieldPath.documentId, whereIn: userBusinesses).get();

    return querySnapshot.docs.map((doc) => Business.fromFirestore(doc)).toList();
  }

  Future<void> updateBusiness(String businessId, Map<String, dynamic> data) async {
    await _db.collection('businesses').doc(businessId).update(data);
  }

  Future<void> addUser(String userId, String name, String email) async {
    await _db.collection('users').doc(userId).set({
      'userId': userId,
      'name': name,
      'email': email,
      'businesses': []
    });
  }

  Future<void> addNotification(String userId, String message) async {
    final docRef = _db.collection('notifications').doc();
    await docRef.set({
      'notificationId': docRef.id,
      'userId': userId,
      'message': message,
      'timestamp': FieldValue.serverTimestamp(),
      'read': false
    });
  }

  Future<List<Notification>> getUserNotifications(String userId) async {
    final querySnapshot = await _db.collection('notifications').where('userId', isEqualTo: userId).orderBy('timestamp', descending: true).get();

    return querySnapshot.docs.map((doc) => Notification.fromFirestore(doc)).toList();
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _db.collection('notifications').doc(notificationId).update({'read': true});
  }

  Future<void> saveSchedule(String businessId, Map<String, Map<String, List<ShiftSchedule>>> schedule) async {
    // Convert the nested schedule to a format that can be stored in Firestore
    Map<String, dynamic> scheduleData = {};
    schedule.forEach((day, shiftsMap) {
      scheduleData[day] = {};
      shiftsMap.forEach((shiftTime, shifts) {
        scheduleData[day][shiftTime] = shifts.map((shift) => {
          'memberId': shift.member.userId,
          'startTime': shift.startTime,
          'endTime': shift.endTime,
        }).toList();
      });
    });

    await FirebaseFirestore.instance.collection('businesses').doc(businessId).update({
      'schedule': scheduleData,
    });
  }
}
