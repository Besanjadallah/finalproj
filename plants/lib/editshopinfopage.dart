import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class EditShopInfoPage extends StatefulWidget {
  const EditShopInfoPage({super.key});

  @override
  State<EditShopInfoPage> createState() => _EditShopInfoPageState();
}

class _EditShopInfoPageState extends State<EditShopInfoPage> {
  final TextEditingController _shopNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<String> _selectedSpecialties = [];

  final List<String> specialties = ['Indoor', 'Outdoor', 'Decorative'];

  final Dio dio = Dio();
  final String apiUrl =
      'http://192.168.56.1:8080/api/shops/add'; // ✅ عدلي IP إذا لزم

  Future<void> _submitShopInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Token missing. Please login again.')),
      );
      return;
    }

    try {
      final response = await dio.post(
        apiUrl,
        data: {
          'name': _shopNameController.text.trim(),
          'address': _addressController.text.trim(),
          'phone': _phoneController.text.trim(),
          'description': _descriptionController.text.trim(),
          'specialties': _selectedSpecialties,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Shop info updated successfully')),
        );
        Navigator.pop(context); // أو إعادة التوجيه حسب ما تريدي
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Failed: ${response.statusMessage}')),
        );
      }
    } catch (e) {
      print('❌ Error submitting shop info: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Shop Info'),
        backgroundColor: const Color(0xFF6D9773),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: _shopNameController,
              decoration: const InputDecoration(labelText: 'Shop Name'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Shop Address'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Shop Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            const Text(
              'Shop Specialties:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Column(
              children:
                  specialties.map((specialty) {
                    return CheckboxListTile(
                      title: Text(specialty),
                      value: _selectedSpecialties.contains(specialty),
                      activeColor: const Color(0xFF6D9773),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedSpecialties.add(specialty);
                          } else {
                            _selectedSpecialties.remove(specialty);
                          }
                        });
                      },
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitShopInfo,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6D9773),
              ),
              child: const Text("Save Shop Info"),
            ),
          ],
        ),
      ),
    );
  }
}
