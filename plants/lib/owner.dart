import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'editshopinfopage.dart';
//import 'edit_profile_page.dart';
import 'profile_page.dart';

final List<Map<String, dynamic>> plants = [
  {
    'name': 'Basil',
    'price': 10.0,
    'quantity': 3,
    'quality': 'Excellent',
    'type': 'Indoor',
    'image': 'assets/images/bg.jpg',
  },
  {
    'name': 'Mint',
    'price': 12.5,
    'quantity': 8,
    'quality': 'Good',
    'type': 'Outdoor',
    'image': 'assets/images/bg.jpg',
  },
  {
    'name': 'Cactus',
    'price': 15.0,
    'quantity': 20,
    'quality': 'Excellent',
    'type': 'Decorative',
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
];

// ================== ShopOwnerDashboard ==================
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
            tooltip: 'Add New Plant',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPlantPage()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Profile',
            onPressed: () {

             Navigator.push(
                context,
               MaterialPageRoute(builder: (_) => const ProfilePage()),

              );
            },
          ),
          IconButton(
  icon: const Icon(Icons.store),
  tooltip: 'Edit Shop Info',
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
            _sectionTitle("Recent Orders"),
            ...orders.map((order) => _orderTile(order)).toList(),
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
                Text("Qty: ${plant['quantity']}", style: TextStyle(fontSize: 14, color: isLow ? Colors.red : Colors.black)),
                Text("Quality: ${plant['quality']}", style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
                Text("Type: ${plant['type']}", style: const TextStyle(fontSize: 14, color: Colors.teal)),
              ],
            ),
          ),
          Column(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => EditPlantPage(plant: plant)));
                },
                icon: const Icon(Icons.edit, color: Colors.orange),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.delete, color: Colors.red),
              ),
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
}

// ================== AddPlantPage ==================
class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  File? _imageFile;
  String _selectedQuality = 'Excellent';
  String _selectedType = 'Indoor';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

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
              Center(child: Image.file(_imageFile!, height: 150)),
            TextButton.icon(
              icon: const Icon(Icons.image, color: Color(0xFF6D9773)),
              label: const Text("Choose Image", style: TextStyle(color: Color(0xFF6D9773))),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 12),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Plant Name')),
            const SizedBox(height: 12),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _quantityController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            Text("Quality"),
            DropdownButton<String>(
              value: _selectedQuality,
              isExpanded: true,
              items: ['Excellent', 'Good', 'Fair', 'Poor']
                  .map((quality) => DropdownMenuItem(value: quality, child: Text(quality)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedQuality = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            Text("Plant Type"),
            DropdownButton<String>(
              value: _selectedType,
              isExpanded: true,
              items: ['Indoor', 'Outdoor', 'Decorative']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // منطق الإضافة هنا
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D9773)),
              child: const Text("Save Plant"),
            )
          ],
        ),
      ),
    );
  }
}

// ================== EditPlantPage ==================
class EditPlantPage extends StatefulWidget {
  final Map<String, dynamic> plant;

  const EditPlantPage({super.key, required this.plant});

  @override
  State<EditPlantPage> createState() => _EditPlantPageState();
}

class _EditPlantPageState extends State<EditPlantPage> {
  File? _imageFile;
  late String _selectedQuality;
  late String _selectedType;
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant['name']);
    _priceController = TextEditingController(text: widget.plant['price'].toString());
    _quantityController = TextEditingController(text: widget.plant['quantity'].toString());
    _selectedQuality = widget.plant['quality'] ?? 'Excellent';
    _selectedType = widget.plant['type'] ?? 'Indoor';
  }

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
      appBar: AppBar(title: const Text('Edit Plant'), backgroundColor: const Color(0xFF6D9773)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (_imageFile != null)
              Center(child: Image.file(_imageFile!, height: 150))
            else
              Center(child: Image.asset(widget.plant['image'], height: 150)),
            TextButton.icon(
              icon: const Icon(Icons.image, color: Color(0xFF6D9773)),
              label: const Text("Change Image", style: TextStyle(color: Color(0xFF6D9773))),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 12),
            TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Plant Name')),
            const SizedBox(height: 12),
            TextField(controller: _priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            TextField(controller: _quantityController, decoration: const InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            Text("Quality"),
            DropdownButton<String>(
              value: _selectedQuality,
              isExpanded: true,
              items: ['Excellent', 'Good', 'Fair', 'Poor']
                  .map((quality) => DropdownMenuItem(value: quality, child: Text(quality)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedQuality = value!;
                });
              },
            ),
            const SizedBox(height: 12),
            Text("Plant Type"),
            DropdownButton<String>(
              value: _selectedType,
              isExpanded: true,
              items: ['Indoor', 'Outdoor', 'Decorative']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // منطق التعديل هنا
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF6D9773)),
              child: const Text("Update Plant"),
            )
          ],
        ),
      ),
    );
  }
}
