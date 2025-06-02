import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// ========== بيانات وهمية ==========
final List<Map<String, dynamic>> plants = [
  {
    'name': 'Basil',
    'price': 10.0,
    'quantity': 3,
    'image': 'assets/images/bg.jpg',
  },
  {
    'name': 'Mint',
    'price': 12.5,
    'quantity': 8,
    'image': 'assets/images/bg.jpg',
  },
  {
    'name': 'Cactus',
    'price': 15.0,
    'quantity': 20,
    'image': 'assets/images/bg.jpg',
  },
  {
    'name': 'Rosemary',
    'price': 9.5,
    'quantity': 2,
    'image': 'assets/images/bg.jpg',
  },
  {
    'name': 'Orchid',
    'price': 25.0,
    'quantity': 6,
    'image': 'assets/images/bg.jpg',
  },
  {
    'name': 'Lavender',
    'price': 14.0,
    'quantity': 4,
    'image': 'assets/images/bg.jpg',
  },
  {
    'name': 'Fern',
    'price': 11.0,
    'quantity': 7,
    'image': 'assets/images/bg.jpg',
  },
];

final List<Map<String, dynamic>> orders = [
  {
    'user': 'Alaa Khaled',
    'plant': 'Cactus',
    'price': 15.0,
    'date': DateTime.now(),
  },
  {
    'user': 'Sara Naser',
    'plant': 'Mint',
    'price': 12.5,
    'date': DateTime.now().subtract(const Duration(days: 1)),
  },
  {
    'user': 'Yousef Zaid',
    'plant': 'Rosemary',
    'price': 9.5,
    'date': DateTime.now().subtract(const Duration(days: 3)),
  },
  {
    'user': 'Lina Omar',
    'plant': 'Orchid',
    'price': 25.0,
    'date': DateTime.now().subtract(const Duration(days: 2)),
  },
  {
    'user': 'Tariq Saleh',
    'plant': 'Lavender',
    'price': 14.0,
    'date': DateTime.now().subtract(const Duration(days: 4)),
  },
  {
    'user': 'Nour Salem',
    'plant': 'Fern',
    'price': 11.0,
    'date': DateTime.now().subtract(const Duration(days: 5)),
  },
];

// ========== شاشة لوحة تحكم صاحب المحل ==========
class ShopOwnerDashboard extends StatelessWidget {
  const ShopOwnerDashboard({super.key});

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
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPlantPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.store),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const EditShopInfoPage()));
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle("Inventory & Alerts"),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: plants.map((plant) => _plantCard(context, plant)).toList(),
            ),
            const SizedBox(height: 24),
            _sectionTitle("Insights"),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _insightCard("Top Selling: Cactus"),
                _insightCard("Monthly Orders: 12"),
              ],
            ),
            const SizedBox(height: 24),
            _sectionTitle("Recent Orders"),
            ...orders.map((order) => _orderTile(order)).toList(),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6D9773),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("Export Monthly Report"),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailedReportPage()));
                },
              ),
            ),
          ],
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
          BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(plant['image'], width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plant['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text("Price: \$${plant['price']}", style: const TextStyle(fontSize: 14)),
                Text("Qty: ${plant['quantity']}",
                    style: TextStyle(fontSize: 14, color: isLow ? Colors.red : Colors.black)),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.edit, color: Colors.orange)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.delete, color: Colors.red)),
            ],
          )
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
        leading: const CircleAvatar(backgroundColor: Color(0xFF6D9773), child: Icon(Icons.person, color: Colors.white)),
        title: Text(order['user'], style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text("Bought ${order['plant']} for \$${order['price']}"),
        trailing: Text(DateFormat('MMM d').format(order['date'])),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _insightCard(String title) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
    );
  }
}

// باقي الصفحات

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Plant'), backgroundColor: const Color(0xFF6D9773)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (_imageFile != null)
              Center(
                child: Image.file(_imageFile!, height: 150),
              ),
            TextButton.icon(
              icon: const Icon(Icons.image, color: Color(0xFF6D9773)),
              label: const Text("Choose Image", style: TextStyle(color: Color(0xFF6D9773))),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 12),
            TextField(decoration: const InputDecoration(labelText: 'Plant Name')),
            const SizedBox(height: 12),
            TextField(decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D9773)),
              child: const Text("Save Plant"),
            )
          ],
        ),
      ),
    );
  }
}

class EditShopInfoPage extends StatelessWidget {
  const EditShopInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Shop Info'), backgroundColor: const Color(0xFF6D9773)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(decoration: const InputDecoration(labelText: 'Shop Name')),
            const SizedBox(height: 12),
            TextField(decoration: const InputDecoration(labelText: 'Address')),
            const SizedBox(height: 12),
            TextField(decoration: const InputDecoration(labelText: 'Phone Number'), keyboardType: TextInputType.phone),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D9773)),
              child: const Text("Update Info"),
            )
          ],
        ),
      ),
    );
  }
}

class DetailedReportPage extends StatelessWidget {
  const DetailedReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monthly Report'), backgroundColor: const Color(0xFF6D9773)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const Icon(Icons.check_circle_outline, color: Color(0xFF6D9773)),
              title: Text(order['user'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${order['plant']} - \$${order['price']}"),
              trailing: Text(DateFormat('yMMMd').format(order['date'])),
            ),
          );
        },
      ),
    );
  }
}
