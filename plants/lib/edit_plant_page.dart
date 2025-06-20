import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String apiBaseUrl = 'http://192.168.56.1:8080';
final Dio dio = Dio();

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
    _priceController = TextEditingController(
      text: widget.plant['price'].toString(),
    );
    _quantityController = TextEditingController(
      text: widget.plant['quantity'].toString(),
    );
    _selectedQuality = widget.plant['quality'] ?? 'Excellent';
    _selectedType = widget.plant['type'] ?? 'Indoor';
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updatePlant() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final formData = FormData.fromMap({
      'name': _nameController.text.trim(),
      'price': _priceController.text.trim(),
      'quantity': _quantityController.text.trim(),
      'quality': _selectedQuality,
      'type': _selectedType,
      if (_imageFile != null)
        'image': await MultipartFile.fromFile(
          _imageFile!.path,
          filename: 'plant.jpg',
        ),
    });

    try {
      final response = await dio.put(
        '$apiBaseUrl/api/plants/${widget.plant['_id']}',
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("✅ Plant updated")));
        Navigator.pop(context, true);
      } else {
        throw Exception("Failed");
      }
    } catch (e) {
      print("❌ Update error: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("❌ Failed to update")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Plant'),
        backgroundColor: const Color(0xFF6D9773),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Center(
              child:
                  _imageFile != null
                      ? Image.file(_imageFile!, height: 150)
                      : Image.network(
                        '$apiBaseUrl${widget.plant['imageUrl'] ?? ''}',
                        height: 150,
                        errorBuilder:
                            (_, __, ___) => Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey,
                            ),
                      ),
            ),
            TextButton.icon(
              icon: const Icon(Icons.image),
              label: const Text("Change Image"),
              onPressed: _pickImage,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Plant Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
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
            const Text("Type"),
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
              onPressed: _updatePlant,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6D9773),
              ),
              child: const Text("Update Plant"),
            ),
          ],
        ),
      ),
    );
  }
}
