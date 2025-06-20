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

  void addItem(String plantId, String name, double price, String image) {
    if (_items.containsKey(plantId)) {
      _items.update(
        plantId,
        (existingItem) => CartItem(
          id: existingItem.id,
          name: existingItem.name,
          price: existingItem.price,
          image: existingItem.image,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _items[plantId] = CartItem(
        id: plantId,
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

  void decreaseQuantity(String id) {
    if (_items.containsKey(id)) {
      final item = _items[id]!;
      if (item.quantity > 1) {
        _items.update(
          id,
          (i) => CartItem(
            id: i.id,
            name: i.name,
            price: i.price,
            image: i.image,
            quantity: i.quantity - 1,
          ),
        );
      } else {
        _items.remove(id);
      }
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  
  List<Map<String, dynamic>> getCartItemsAsJson() {
  final data = _items.values.map((item) => {
    "plantId": item.id,
    "quantity": item.quantity,
  }).toList();

  print("📦 Cart JSON: $data");

  return data;
}

}
