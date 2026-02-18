/// Constants for Firestore collection names and field keys.
class FirebaseConstants {
  FirebaseConstants._();

  // Collections
  static const String usersCollection = 'users';
  static const String restaurantCollection = 'restaurant';
  static const String menuItemsCollection = 'menu_items';
  static const String ordersCollection = 'orders';
  static const String categoriesCollection = 'categories';

  // Restaurant doc ID (single restaurant)
  static const String restaurantDocId = 'main_restaurant';

  // Order statuses
  static const String statusPlaced = 'placed';
  static const String statusAccepted = 'accepted';
  static const String statusPreparing = 'preparing';
  static const String statusOutForDelivery = 'out_for_delivery';
  static const String statusDelivered = 'delivered';

  // Payment methods
  static const String paymentUpi = 'upi';
  static const String paymentCash = 'cash';

  // User roles
  static const String roleCustomer = 'customer';
  static const String roleOwner = 'owner';
}
