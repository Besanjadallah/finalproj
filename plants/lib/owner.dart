import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add-plant-page.dart';
import 'edit_profile_page.dart';
import 'editshopinfopage.dart';
import 'edit_plant_page.dart';

const String apiBaseUrl = 'http://192.168.56.1:8080';
final Dio dio = Dio();

class ShopOwnerDashboard extends StatefulWidget {
  const ShopOwnerDashboard({super.key});

  @override
  State<ShopOwnerDashboard> createState() => _ShopOwnerDashboardState();
}

class _ShopOwnerDashboardState extends State<ShopOwnerDashboard> {
  List<Map<String, dynamic>> plants = [];
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final shopId = prefs.getString('shopId');
    final token = prefs.getString('token');

    try {
      final plantRes = await dio.get('$apiBaseUrl/api/plants/shop/$shopId');
      final orderRes = await dio.get(
        '$apiBaseUrl/api/orders/shop/$shopId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      setState(() {
        plants = List<Map<String, dynamic>>.from(plantRes.data);
        orders = List<Map<String, dynamic>>.from(orderRes.data);
      });
    } catch (e) {
      print("❌ Error loading data: $e");
    }
  }

  Future<void> _deletePlant(String plantId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await dio.delete(
        '$apiBaseUrl/api/plants/$plantId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        setState(() => plants.removeWhere((p) => p['_id'] == plantId));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Plant deleted')));
      } else {
        print('❌ Delete failed: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Failed to delete plant')),
        );
      }
    } catch (e) {
      print('❌ Error deleting plant: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Error deleting plant')));
    }
  }

  Future<void> _deleteOrder(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    try {
      final response = await dio.delete(
        '$apiBaseUrl/api/orders/$orderId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        setState(() => orders.removeWhere((o) => o['_id'] == orderId));
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('✅ Order deleted')));
      } else {
        print('❌ Failed to delete order: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error deleting order: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Error deleting order')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EE),
      appBar: AppBar(
        title: const Text('Shop Dashboard'),
        backgroundColor: const Color(0xFF6D9773),
        elevation: 4,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            tooltip: 'Add New Plant',
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddPlantPage()),
              );
              if (result == true) {
                _fetchData(); // ✅ تحديث الصفحة الرئيسية بعد الإضافة
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfilePage()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.store),
            tooltip: 'Edit Shop Info',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditShopInfoPage()),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _fetchData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Inventory & Alerts",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children:
                    plants.map((plant) => _plantCard(context, plant)).toList(),
              ),
              const SizedBox(height: 24),
              const Text(
                "Recent Orders",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              ...orders.map((order) => _orderTile(order)).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _plantCard(BuildContext context, Map<String, dynamic> plant) {
    final isLow = plant['quantity'] < 5;
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: isLow ? Colors.red[50] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              '$apiBaseUrl${plant['imageUrl'] ?? ''}',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => const Icon(Icons.image_not_supported),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  plant['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text("Price: \$${plant['price']}"),
                Text(
                  "Qty: ${plant['quantity']}",
                  style: TextStyle(color: isLow ? Colors.red : Colors.black),
                ),
                Text("Quality: ${plant['quality']}"),
                Text("Type: ${plant['type']}"),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.orange),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditPlantPage(plant: plant),
                    ),
                  );
                  if (result == true) {
                    _fetchData(); // ✅ تحديث بعد التعديل
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deletePlant(plant['_id']),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orderTile(Map<String, dynamic> order) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Color(0xFF6D9773),
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(order['user'] ?? 'Unknown User'),
        subtitle: Text("Total: \$${order['totalPrice']}"),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => _deleteOrder(order['_id']),
        ),
      ),
    );
  }
}
