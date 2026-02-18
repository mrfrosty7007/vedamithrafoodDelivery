import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/firebase_constants.dart';

/// Generic Firestore CRUD service.
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ---------- Users ----------

  Future<void> createUser(String uid, Map<String, dynamic> data) async {
    await _db.collection(FirebaseConstants.usersCollection).doc(uid).set(data);
  }

  Future<Map<String, dynamic>?> getUser(String uid) async {
    final doc =
        await _db.collection(FirebaseConstants.usersCollection).doc(uid).get();
    return doc.data();
  }

  // ---------- Menu Items ----------

  Stream<QuerySnapshot> getMenuItems() {
    return _db
        .collection(FirebaseConstants.menuItemsCollection)
        .orderBy('category')
        .snapshots();
  }

  Future<void> addMenuItem(String id, Map<String, dynamic> data) async {
    await _db
        .collection(FirebaseConstants.menuItemsCollection)
        .doc(id)
        .set(data);
  }

  Future<void> updateMenuItem(String id, Map<String, dynamic> data) async {
    await _db
        .collection(FirebaseConstants.menuItemsCollection)
        .doc(id)
        .update(data);
  }

  Future<void> deleteMenuItem(String id) async {
    await _db
        .collection(FirebaseConstants.menuItemsCollection)
        .doc(id)
        .delete();
  }

  // ---------- Orders ----------

  Future<void> createOrder(String id, Map<String, dynamic> data) async {
    await _db
        .collection(FirebaseConstants.ordersCollection)
        .doc(id)
        .set(data);
  }

  Stream<QuerySnapshot> getLiveOrders() {
    return _db
        .collection(FirebaseConstants.ordersCollection)
        .where('status', whereNotIn: ['delivered'])
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getCustomerOrders(String customerId) {
    return _db
        .collection(FirebaseConstants.ordersCollection)
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _db
        .collection(FirebaseConstants.ordersCollection)
        .doc(orderId)
        .update({
      'status': status,
      'updatedAt': Timestamp.now(),
    });
  }

  Stream<DocumentSnapshot> getOrderStream(String orderId) {
    return _db
        .collection(FirebaseConstants.ordersCollection)
        .doc(orderId)
        .snapshots();
  }

  // ---------- Restaurant ----------

  Stream<DocumentSnapshot> getRestaurantStream() {
    return _db
        .collection(FirebaseConstants.restaurantCollection)
        .doc(FirebaseConstants.restaurantDocId)
        .snapshots();
  }

  Future<void> updateRestaurant(Map<String, dynamic> data) async {
    await _db
        .collection(FirebaseConstants.restaurantCollection)
        .doc(FirebaseConstants.restaurantDocId)
        .set(data, SetOptions(merge: true));
  }

  // ---------- Categories ----------

  Stream<QuerySnapshot> getCategories() {
    return _db
        .collection(FirebaseConstants.categoriesCollection)
        .orderBy('sortOrder')
        .snapshots();
  }

  // ---------- Revenue ----------

  Future<QuerySnapshot> getOrdersForDate(DateTime date) async {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return _db
        .collection(FirebaseConstants.ordersCollection)
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('createdAt', isLessThan: Timestamp.fromDate(end))
        .where('status', isEqualTo: 'delivered')
        .get();
  }
}
