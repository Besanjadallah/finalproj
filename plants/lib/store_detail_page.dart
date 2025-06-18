<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'plant_detail_page.dart';
import 'providers/cart_provider.dart';
=======
// ✅ store_detail_page.dart (معدل ليفتح PlantDetailPage ويظهر AI info من ChatGPT)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'plant_detail_page.dart';
import 'providers/cart_provider.dart';
import 'providers/favorite_provider.dart';
>>>>>>> tasneem-upload

class StoreDetailPage extends StatefulWidget {
  final String storeName;

  const StoreDetailPage({super.key, required this.storeName});

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
<<<<<<< HEAD
  String? userId;
  Set<String> favoritePlantIds = {};

  final List<Map<String, dynamic>> allPlants = [
    {
      '_id': '6852cbeba594d937d9bcd900',
      'name': 'Lavender',
      'store': 'Green Garden',
      'category': 'Outdoor',
      'image': 'assets/images/lavender.jpg',
      'temperature': '20-28°C',
      'lighting': 'Full Sun',
      'watering': 'Once a week',
      'price': 25.0,
=======
  final List<Map<String, dynamic>> allPlants = [
    {
      'name': 'Monstera',
      'store': 'Green Garden',
      'category': 'Indoor',
      'image': 'assets/images/monstera.jpg',
      'temperature': '20-28°C',
      'lighting': 'Indirect light',
      'watering': 'Every 1-2 weeks',
      'price': 20.0,
    },
    {
      'name': 'Cactus',
      'store': 'Nature Bloom',
      'category': 'Outdoor',
      'image': 'assets/images/cactus.jpg',
      'temperature': '18-35°C',
      'lighting': 'Full sun',
      'watering': 'Every 3 weeks',
      'price': 15.0,
    },
    {
      'name': 'Snake Plant',
      'store': 'Green Garden',
      'category': 'Indoor',
      'image': 'assets/images/snake_plant.jpg',
      'temperature': '15-30°C',
      'lighting': 'Low to bright light',
      'watering': 'Every 2-3 weeks',
      'price': 18.0,
    },
    {
      'name': 'Bamboo',
      'store': 'Leafy Living',
      'category': 'Indoor',
      'image': 'assets/images/bamboo.jpg',
      'temperature': '18-35°C',
      'lighting': 'Partial light',
      'watering': 'Grows in water',
      'price': 22.0,
>>>>>>> tasneem-upload
    },
  ];

  String selectedCategory = 'All';

  @override
<<<<<<< HEAD
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    if (userId != null) {
      await fetchFavorites();
    }
  }

  Future<void> fetchFavorites() async {
    try {
      final res = await http.get(Uri.parse("http://localhost:8080/api/favorites/$userId"));
      if (res.statusCode == 200) {
        final List data = json.decode(res.body);
        setState(() {
          favoritePlantIds = data.map((item) => item['plantId'].toString()).toSet();
        });
      }
    } catch (e) {
      debugPrint("Error fetching favorites: $e");
    }
  }

  Future<void> toggleFavorite(Map<String, dynamic> plant) async {
  final plantId = plant['_id'];
  print("🪴 كامل بيانات النبتة: $plant");

  if (userId == null || plantId == null) {
    print("❌ إما userId أو plantId مفقود");
    return;
  }

  print("🧪 Sending plantId: $plantId");

  if (favoritePlantIds.contains(plantId)) {
    print("🗑️ النبات موجود مسبقًا، جاري الحذف من المفضلة...");
    final res = await http.delete(
      Uri.parse("http://localhost:8080/api/favorites/remove"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "userId": userId,
        "productId": plantId,
      }),
    );
    print("📩 Response: ${res.body}");
    if (res.statusCode == 200) {
      print("✅ تم الحذف بنجاح");
      setState(() {
        favoritePlantIds.remove(plantId);
      });
    }
  } else {
    print("➕ النبات غير موجود، سيتم إضافته للمفضلة...");
    final res = await http.post(
      Uri.parse("http://localhost:8080/api/favorites/add"),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        "userId": userId,
        "productId": plantId,
        "name": plant['name'],
        "image": plant['image'],
        "price": plant['price'].toString()
      }),
    );
    print("📩 Response: ${res.body}");
    if (res.statusCode == 201) {
      print("✅ تم الإضافة للمفضلة بنجاح");
      setState(() {
        favoritePlantIds.add(plantId);
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
=======
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
    final fav = Provider.of<FavoriteProvider>(context);
>>>>>>> tasneem-upload
    final categories = ['All', 'Indoor', 'Outdoor', 'Garden', 'Big Plants', 'Small Plants'];

    final filteredPlants = allPlants.where((plant) {
      final storeMatch = plant['store'] == widget.storeName;
      final categoryMatch = selectedCategory == 'All' || plant['category'] == selectedCategory;
      return storeMatch && categoryMatch;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8DBF67),
        title: Text(widget.storeName, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
<<<<<<< HEAD
            decoration: const BoxDecoration(
              gradient: LinearGradient(
=======
            decoration: BoxDecoration(
              gradient: const LinearGradient(
>>>>>>> tasneem-upload
                colors: [Color(0xFFa5d88e), Color(0xFF8DBF67)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
<<<<<<< HEAD
              borderRadius: BorderRadius.only(
=======
              borderRadius: const BorderRadius.only(
>>>>>>> tasneem-upload
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ChoiceChip(
                      label: Text(cat, style: const TextStyle(color: Colors.white)),
                      selected: selectedCategory == cat,
                      onSelected: (_) {
                        setState(() {
                          selectedCategory = cat;
                        });
                      },
                      selectedColor: Colors.green[800],
                      backgroundColor: Colors.green[400],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredPlants.isEmpty
                ? const Center(child: Text('No plants found for this category.'))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: filteredPlants.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.7,
                      ),
                      itemBuilder: (context, index) {
                        final plant = filteredPlants[index];
<<<<<<< HEAD
                        final plantId = plant['_id'];
                        final isFav = favoritePlantIds.contains(plantId);

=======
>>>>>>> tasneem-upload
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => PlantDetailPage(
                                            imagePath: plant['image'],
                                            name: plant['name'],
                                            temperature: plant['temperature'],
                                            lighting: plant['lighting'],
                                            watering: plant['watering'],
<<<<<<< HEAD
                                            price: plant['price'],
=======
>>>>>>> tasneem-upload
                                          ),
                                        ),
                                      );
                                    },
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                      child: Image.asset(
                                        plant['image'],
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      plant['name'],
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    child: Text(
                                      "₪${plant['price']}",
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                  const Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF8DBF67),
                                        minimumSize: const Size.fromHeight(36),
                                      ),
                                      onPressed: () {
                                        cart.addItem(
                                          plant['name'],
                                          plant['name'],
                                          plant['price'],
                                          plant['image'],
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Added to cart!')),
                                        );
                                      },
                                      icon: const Icon(Icons.add_shopping_cart, size: 18),
                                      label: const Text("Add to Cart"),
                                    ),
<<<<<<< HEAD
                                  ),
=======
                                  )
>>>>>>> tasneem-upload
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
<<<<<<< HEAD
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () => toggleFavorite(plant),
=======
                                  fav.isFavorite(plant['name'])
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  fav.toggleFavorite(
                                    plant['name'],
                                    plant['name'],
                                    plant['image'],
                                  );
                                },
>>>>>>> tasneem-upload
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
