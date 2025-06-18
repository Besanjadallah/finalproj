import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<dynamic> favorites = [];
  String? userId;
  String? token;

  @override
  void initState() {
    super.initState();
    _loadUserAndFetchFavorites();
  }

  Future<void> _loadUserAndFetchFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    token = prefs.getString('token');
    if (userId != null && token != null) {
      await fetchFavorites();
    } else {
      print("❌ userId أو token غير موجود!");
    }
  }

  Future<void> fetchFavorites() async {
    final url = Uri.parse("http://localhost:8080/api/favorites/");
    try {
      final res = await http.get(url, headers: {
        "Authorization": "Bearer $token",
      });

      if (res.statusCode == 200) {
        final List raw = json.decode(res.body);
        print("✅ Favorites fetched: $raw");
        setState(() {
          favorites = raw;
        });
      } else {
        print("❌ Error loading favorites: ${res.body}");
      }
    } catch (e) {
      print("🔥 Exception fetching favorites: $e");
    }
  }

  Future<void> removeFavorite(String plantId) async {
    if (userId == null || token == null) return;

    final url = Uri.parse("http://localhost:8080/api/favorites/remove");
    try {
      final res = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: json.encode({
          "userId": userId,
           "plantId": plantId,
        }),
      );

      print("🗑️ Delete response: ${res.body}");

      if (res.statusCode == 200) {
        setState(() {
          favorites.removeWhere((item) => item['plantId'] == plantId);
        });
      } else {
        print("❌ Failed to remove favorite: ${res.body}");
      }
    } catch (e) {
      print("🔥 Exception removing favorite: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
=======
import 'package:provider/provider.dart';
import 'plant_detail_page.dart';
import 'providers/favorite_provider.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<FavoriteProvider>(context);
    final favorites = favoriteProvider.favorites;

>>>>>>> tasneem-upload
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Favorites'),
        backgroundColor: const Color(0xFF8DBF67),
      ),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites yet 💔'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (ctx, index) {
<<<<<<< HEAD
                final plant = favorites[index];

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: Image.asset(
                      plant['image'] ?? 'assets/images/placeholder.jpg',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(plant['name'] ?? 'No name'),
                    subtitle: Text("₪${plant['price'] ?? 'N/A'}"),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => removeFavorite(plant['plantId']),
                    ),
=======
                final item = favorites[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    leading: Image.asset(item.image, width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(item.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        favoriteProvider.removeFavorite(item.id);
                      },
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PlantDetailPage(
                            imagePath: item.image,
                            name: item.name,
                            temperature: 'N/A',
                            lighting: 'N/A',
                            watering: 'N/A',
                          ),
                        ),
                      );
                    },
>>>>>>> tasneem-upload
                  ),
                );
              },
            ),
    );
  }
}
