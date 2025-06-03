import 'package:flutter/material.dart';

class FavoriteItem {
  final String id;
  final String name;
  final String image;

  FavoriteItem({required this.id, required this.name, required this.image});
}

class FavoriteProvider with ChangeNotifier {
  final List<FavoriteItem> _favoriteItems = [];

  // ✅ هذا هو getter للمفضلات
  List<FavoriteItem> get favorites => _favoriteItems;

  // ✅ هذا للفحص إذا المنتج مفضل
  bool isFavorite(String id) {
    return _favoriteItems.any((item) => item.id == id);
  }

  // ✅ هذه لتبديل حالة المفضلة
  void toggleFavorite(String id, String name, String image) {
    final existingIndex = _favoriteItems.indexWhere((item) => item.id == id);
    if (existingIndex >= 0) {
      _favoriteItems.removeAt(existingIndex);
    } else {
      _favoriteItems.add(FavoriteItem(id: id, name: name, image: image));
    }
    notifyListeners();
  }

  // ✅ هذه هي الدالة اللي كانت ناقصة
  void removeFavorite(String id) {
    _favoriteItems.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
