import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';


class FavoriteItem {
  final String id;
  final String name;
  final String image;

  FavoriteItem({required this.id, required this.name, required this.image});

  factory FavoriteItem.fromJson(Map<String, dynamic> json) {
    final plant = json['plantId'];
    return FavoriteItem(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

class FavoriteProvider with ChangeNotifier {
  List<FavoriteItem> _favoriteItems = [];

  List<FavoriteItem> get favorites => _favoriteItems;

 final String baseUrl = 'http://192.168.1.213:8080/api/favorites'; // ← IP جهازك الحقيقي

  Future<void> fetchFavorites() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        _favoriteItems = data.map((item) => FavoriteItem.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("خطأ في جلب المفضلات: $e");
    }
  }

  bool isFavorite(String id) {
    return _favoriteItems.any((item) => item.id == id);
  }

  Future<void> toggleFavorite(String id, String name, String image) async {
  final existingIndex = _favoriteItems.indexWhere((item) => item.id == id);

  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId'); // ✅ نحصل على userId الحقيقي

  if (userId == null) {
    debugPrint("❌ لا يوجد userId مخزن!");
    return;
  }

  if (existingIndex >= 0) {
    // إذا كانت موجودة، احذفها
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/remove'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({'userId': userId, 'productId': id}),
      );
      if (res.statusCode == 200) {
        _favoriteItems.removeAt(existingIndex);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("❌ خطأ في حذف المفضلة: $e");
    }
  } else {
    // إذا مش موجودة، أضفها
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/add'),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'userId': userId,
          'plantId': id,
          'name': name,
          'image': image,
        }),
      );
      print("🧪 response.body: ${res.body}");
      print("🧪 statusCode: ${res.statusCode}");


      if (res.statusCode == 201) {
        _favoriteItems.add(FavoriteItem(id: id, name: name, image: image));
        notifyListeners();
      }
    } catch (e) {
      debugPrint("❌ خطأ في إضافة المفضلة: $e");
    }
  }
  }

  Future<void> removeFavorite(String id) async {
    try {
      final res = await http.delete(Uri.parse('$baseUrl/$id'));
      if (res.statusCode == 200) {
        _favoriteItems.removeWhere((item) => item.id == id);
        notifyListeners();
      }
    } catch (e) {
      debugPrint("خطأ في إزالة المفضلة: $e");
    }
  }
}
