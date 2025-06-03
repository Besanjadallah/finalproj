import 'package:flutter/material.dart';
import '../models/cart_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalPrice {
    double total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  void addItem(String id, String name, double price, String image) {
    if (_items.containsKey(id)) {
      // ✅ استخدم update لتحديث العنصر بشكل آمن
      _items.update(
        id,
        (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          price: existingItem.price,
          image: existingItem.image,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items[id] = CartItem(
        id: id,
        name: name,
        price: price,
        image: image,
        quantity: 1,
      );
    }
    notifyListeners();
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void decreaseQuantity(String id) {
    if (_items.containsKey(id)) {
      final existingItem = _items[id]!;
      if (existingItem.quantity > 1) {
        _items.update(
          id,
          (item) => CartItem(
            id: item.id,
            name: item.name,
            price: item.price,
            image: item.image,
            quantity: item.quantity - 1,
          ),
        );
      } else {
        _items.remove(id);
      }
      notifyListeners();
    }
  }
}
