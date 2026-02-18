import 'menu_item_model.dart';

class CartItemModel {
  final MenuItemModel menuItem;
  int quantity;

  CartItemModel({
    required this.menuItem,
    this.quantity = 1,
  });

  double get totalPrice => menuItem.price * quantity;

  Map<String, dynamic> toMap() {
    return {
      'menuItemId': menuItem.id,
      'name': menuItem.name,
      'price': menuItem.price,
      'quantity': quantity,
      'totalPrice': totalPrice,
    };
  }
}
