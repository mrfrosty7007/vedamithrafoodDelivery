import 'package:flutter/material.dart';
import '../../../data/models/cart_item_model.dart';
import '../../../data/models/menu_item_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  int get totalQuantity =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  double get totalAmount =>
      _items.fold(0.0, (sum, item) => sum + item.totalPrice);

  void addItem(MenuItemModel menuItem) {
    final existingIndex =
        _items.indexWhere((item) => item.menuItem.id == menuItem.id);
    if (existingIndex >= 0) {
      _items[existingIndex].quantity++;
    } else {
      _items.add(CartItemModel(menuItem: menuItem));
    }
    notifyListeners();
  }

  void removeItem(String menuItemId) {
    _items.removeWhere((item) => item.menuItem.id == menuItemId);
    notifyListeners();
  }

  void incrementQuantity(String menuItemId) {
    final index =
        _items.indexWhere((item) => item.menuItem.id == menuItemId);
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String menuItemId) {
    final index =
        _items.indexWhere((item) => item.menuItem.id == menuItemId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  List<Map<String, dynamic>> toOrderItems() {
    return _items.map((item) => item.toMap()).toList();
  }
}
