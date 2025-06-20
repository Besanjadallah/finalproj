import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String apiBaseUrl = 'http://192.168.56.1:8080'; // غيّري IP حسب جهازك
final Dio dio = Dio();

class ViewShopsPage extends StatefulWidget {
  const ViewShopsPage({super.key});

  @override
  State<ViewShopsPage> createState() => _ViewShopsPageState();
}

class _ViewShopsPageState extends State<ViewShopsPage> {
  List<Map<String, dynamic>> shops = [];

  @override
  void initState() {
    super.initState();
    fetchShops();
  }

  Future<void> fetchShops() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await dio.get(
        '$apiBaseUrl/api/shops/all',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data as List;

      setState(() {
        shops = data.map((shop) {
          final owner = shop['ownerId'];
          return {
            'id': shop['_id'],
            'shopName': shop['name'],
            'ownerName': owner is Map && owner.containsKey('name') ? owner['name'] : 'Unknown',
            'phone': shop['phone'],
            'address': shop['address'],
            'description': shop['description'],
            'specialties': (shop['specialties'] as List).join(', ')
          };
        }).toList();
      });
    } catch (e) {
      print('❌ Error fetching shops: $e');
    }
  }

  Future<void> deleteShop(String shopId, int index) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      await dio.delete(
        '$apiBaseUrl/api/shops/$shopId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      setState(() {
        shops.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Shop deleted successfully')),
      );
    } catch (e) {
      print('❌ Error deleting shop: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Failed to delete shop')),
      );
    }
  }

  void confirmDelete(String shopId, int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: const Text('Are you sure you want to delete this shop?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              deleteShop(shopId, index);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EE),
      appBar: AppBar(
        title: const Text('All Shops'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6D9773),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth > 900
                    ? 3
                    : constraints.maxWidth > 600
                        ? 2
                        : 1,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1.8,
              ),
              itemCount: shops.length,
              itemBuilder: (context, index) {
                final shop = shops[index];

                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.storefront, color: Color(0xFF6D9773), size: 28),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                shop['shopName'] ?? '',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF344E41),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.person_outline, color: Colors.grey, size: 20),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(shop['ownerName'] ?? ''),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.phone, color: Colors.grey, size: 20),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(shop['phone'] ?? ''),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.grey, size: 20),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(shop['address'] ?? ''),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.info_outline, color: Colors.grey, size: 20),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(shop['description'] ?? ''),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.category, color: Colors.grey, size: 20),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(shop['specialties'] ?? ''),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            tooltip: 'Delete this shop',
                            onPressed: () => confirmDelete(shop['id'], index),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
