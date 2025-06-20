import 'package:flutter/material.dart';

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

  // تخصص المحل (قائمة فيها الخيارات المختارة)
  final List<String> _selectedSpecialties = [];

  // قائمة التخصصات
  final List<String> specialties = ['Indoor', 'Outdoor', 'Decorative'];

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
            const SizedBox(height: 8),
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
              onPressed: () {
                // هنا يمكن تخزين بيانات المحل
                print('Shop Name: ${_shopNameController.text}');
                print('Address: ${_addressController.text}');
                print('Phone: ${_phoneController.text}');
                print('Description: ${_descriptionController.text}');
                print('Specialties: $_selectedSpecialties');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Shop info saved successfully!'),
                  ),
                );
              },
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
