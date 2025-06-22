import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String apiBaseUrl = 'http://192.168.56.1:8080'; // غيّري الـ IP إذا لازم
final Dio dio = Dio();

class ViewShopOwnersPage extends StatefulWidget {
  const ViewShopOwnersPage({super.key});

  @override
  State<ViewShopOwnersPage> createState() => _ViewShopOwnersPageState();
}

class _ViewShopOwnersPageState extends State<ViewShopOwnersPage> {
  List<Map<String, dynamic>> owners = [];

  @override
  void initState() {
    super.initState();
    fetchShopOwners();
  }

  Future<void> fetchShopOwners() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    try {
      final response = await dio.get(
        '$apiBaseUrl/api/users/shopowners',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data as List;

      setState(() {
        owners =
            data
                .map(
                  (owner) => {
                    'id': owner['_id'],
                    'name': owner['name'],
                    'email': owner['email'],
                    'phone': owner['phone'],
                    'address': owner['address'],
                  },
                )
                .toList();
      });
    } catch (e) {
      print('❌ Error fetching shop owners: $e');
    }
  }

  void _deleteOwner(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final ownerId = owners[index]['id'];

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete Owner'),
            content: const Text(
              'Are you sure you want to delete this shop owner?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await dio.delete(
                      '$apiBaseUrl/api/users/$ownerId',
                      options: Options(
                        headers: {'Authorization': 'Bearer $token'},
                      ),
                    );

                    setState(() {
                      owners.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Shop owner deleted successfully'),
                      ),
                    );
                  } catch (e) {
                    print('❌ Error deleting owner: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('❌ Failed to delete shop owner'),
                      ),
                    );
                  }

                  Navigator.pop(context);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }

  void _startChatWithOwner(String ownerName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chat with $ownerName will be implemented soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EE),
      appBar: AppBar(
        title: const Text('Shop Owners'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6D9773),
      ),
      body:
          owners.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            constraints.maxWidth > 900
                                ? 3
                                : constraints.maxWidth > 600
                                ? 2
                                : 1,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.6,
                      ),
                      itemCount: owners.length,
                      itemBuilder: (context, index) {
                        final owner = owners[index];
                        return Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.person,
                                      color: Color(0xFF6D9773),
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(
                                        owner['name'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.email,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(child: Text(owner['email'] ?? '')),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.phone,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(child: Text(owner['phone'] ?? '')),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Flexible(
                                      child: Text(owner['address'] ?? ''),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    tooltip: 'Delete owner',
                                    onPressed: () => _deleteOwner(index),
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
