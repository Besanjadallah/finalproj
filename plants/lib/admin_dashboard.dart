import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Dashboard',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFA8D5BA),
          primary: const Color(0xFF4C9F70),
          secondary: const Color(0xFF73C088),
          background: const Color(0xFFA8D5BA),
        ),
        scaffoldBackgroundColor: const Color(0xFFA8D5BA),
      ),
      home: const ProfileDashboard(),
    );
  }
}

class ProfileDashboard extends StatefulWidget {
  const ProfileDashboard({super.key});

  @override
  State<ProfileDashboard> createState() => _ProfileDashboardState();
}

class _ProfileDashboardState extends State<ProfileDashboard> {
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  final List<Map<String, dynamic>> _features = [
    {'icon': Icons.search, 'title': 'Search'},
    {'icon': Icons.person_add, 'title': 'Add Shop Owner'},
    {'icon': Icons.store_mall_directory, 'title': 'Add Shop'},
    {'icon': Icons.people, 'title': 'View Users'},
    {'icon': Icons.business, 'title': 'View Shop Owners'},
    {'icon': Icons.delete, 'title': 'Delete Account'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _selectedImage != null
                        ? FileImage(_selectedImage!)
                        : const AssetImage('assets/images/user.png') as ImageProvider,
                  ),
                  Positioned(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Sewar Asaad',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF2D5C42)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Palestine | Joined: May 2025',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 28),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _features.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final item = _features[index];
                  return _buildCard(context, item['icon'], item['title'], () {});
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        color: const Color(0xFF4C9F70),
        shadowColor: Colors.black26,
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
