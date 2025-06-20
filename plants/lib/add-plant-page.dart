import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

const String apiBaseUrl = 'http://192.168.56.1:8080';
final Dio dio = Dio();

class AddPlantPage extends StatefulWidget {
  const AddPlantPage({super.key});

  @override
  State<AddPlantPage> createState() => _AddPlantPageState();
}

class _AddPlantPageState extends State<AddPlantPage> {
  File? _imageFile;
  String? _imageFileName;
  String _selectedQuality = 'Excellent';
  String _selectedType = 'Indoor';

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null && !kIsWeb) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _imageFileName = pickedFile.name;
      });
    } else if (pickedFile != null && kIsWeb) {
      setState(() {
        _imageFileName = pickedFile.name;
      });
    }
  }

  Future<void> _submitPlant() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final shopId = prefs.getString('shopId');

    if (token == null || shopId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Missing token or shopId')),
      );
      return;
    }

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text) ?? 0.0;
    final quantity = int.tryParse(_quantityController.text) ?? 0;

    try {
      final formData = FormData.fromMap({
        'shopId': shopId,
        'name': name,
        'price': price,
        'quantity': quantity,
        'quality': _selectedQuality,
        'type': _selectedType,
        if (_imageFile != null)
          'image': await MultipartFile.fromFile(
            _imageFile!.path,
            filename: _imageFileName ?? 'plant.jpg',
          ),
      });

      final response = await dio.post(
        '$apiBaseUrl/api/plants/add',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Plant added successfully')),
        );
        Navigator.pop(context, true); // ✅ مع قيمة ترجع بأن في تعديل صار
      } else {
        throw Exception('Failed');
      }
    } catch (e) {
      print('❌ Error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('❌ Failed to add plant')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Plant'),
        backgroundColor: const Color(0xFF6D9773),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (_imageFileName != null)
              Center(child: Text('📷 Selected: $_imageFileName')),
            TextButton.icon(
              icon: const Icon(Icons.image, color: Color(0xFF6D9773)),
              label: const Text(
                "Choose Image",
                style: TextStyle(color: Color(0xFF6D9773)),
              ),
              onPressed: _pickImage,
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Plant Name'),
            ),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            const Text("Quality"),
            DropdownButton<String>(
              value: _selectedQuality,
              isExpanded: true,
              items:
                  ['Excellent', 'Good', 'Fair', 'Poor']
                      .map((q) => DropdownMenuItem(value: q, child: Text(q)))
                      .toList(),
              onChanged: (value) => setState(() => _selectedQuality = value!),
            ),
            const SizedBox(height: 12),
            const Text("Plant Type"),
            DropdownButton<String>(
              value: _selectedType,
              isExpanded: true,
              items:
                  ['Indoor', 'Outdoor', 'Decorative']
                      .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                      .toList(),
              onChanged: (value) => setState(() => _selectedType = value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPlant,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6D9773),
              ),
              child: const Text("Save Plant"),
            ),
          ],
        ),
      ),
    );
  }
}
