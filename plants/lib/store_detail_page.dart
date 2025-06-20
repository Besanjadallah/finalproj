import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'plant_detail_page.dart';
import 'providers/cart_provider.dart';

class StoreDetailPage extends StatefulWidget {
  final String storeName;

  const StoreDetailPage({super.key, required this.storeName});

  @override
  State<StoreDetailPage> createState() => _StoreDetailPageState();
}

class _StoreDetailPageState extends State<StoreDetailPage> {
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
    },
    {
      '_id': '684ae401bde4925a6fe75295',
      'name': 'Rose',
      'store': 'Nature House',
      'category': 'Outdoor',
      'image': 'assets/images/flower.jpg',
      'temperature': '15-26°C',
      'lighting': 'Full Sun',
      'watering': '2-3 per week',
      'price': 30.0,
    },
  ];

  String selectedCategory = 'All';

  @override
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
    if (userId == null || plantId == null) return;

    if (favoritePlantIds.contains(plantId)) {
      final res = await http.delete(
        Uri.parse("http://localhost:8080/api/favorites/remove"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({"userId": userId, "productId": plantId}),
      );
      if (res.statusCode == 200) {
        setState(() => favoritePlantIds.remove(plantId));
      }
    } else {
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
      if (res.statusCode == 201) {
        setState(() => favoritePlantIds.add(plantId));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);
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
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFa5d88e), Color(0xFF8DBF67)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
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
                        setState(() => selectedCategory = cat);
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
                        final plantId = plant['_id'];
                        final isFav = favoritePlantIds.contains(plantId);

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
                                            id: plant['_id'],
                                            imagePath: plant['image'],
                                            name: plant['name'],
                                            temperature: plant['temperature'],
                                            lighting: plant['lighting'],
                                            watering: plant['watering'],
                                            price: plant['price'].toDouble(),
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
                                          plant['_id'],
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
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () => toggleFavorite(plant),
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
