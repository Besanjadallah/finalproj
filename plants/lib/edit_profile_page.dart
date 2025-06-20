import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  @override
void initState() {
  super.initState();
  _loadUserInfo();
}

Future<void> _loadUserInfo() async {
  final prefs = await SharedPreferences.getInstance();
  setState(() {
    _nameController.text = prefs.getString('name') ?? '';
    _emailController.text = prefs.getString('email') ?? '';
    _phoneController.text = prefs.getString('phone') ?? '';
    _addressController.text = prefs.getString('address') ?? '';
  });
}


  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveChanges() async {
    print("🟢 Save Changes button pressed");

  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  var uri = Uri.parse('http://192.168.1.86:8080/api/users/update-profile'); // غيّري الـ IP حسب السيرفر
  var request = http.MultipartRequest('PUT', uri);


print("🔄 Preparing update request...");
print("Name: ${_nameController.text}");
print("Email: ${_emailController.text}");
print("Password: ${_passwordController.text}");
print("Phone: ${_phoneController.text}");
print("Address: ${_addressController.text}");

  // أضف التوكن في الهيدر
  request.headers['Authorization'] = 'Bearer $token';

  // أضف البيانات
  request.fields['name'] = _nameController.text;
  request.fields['email'] = _emailController.text;
  request.fields['password'] = _passwordController.text;
  request.fields['phone'] = _phoneController.text;
  request.fields['address'] = _addressController.text;

  // لو الصورة تم اختيارها
  if (_selectedImage != null) {
    request.files.add(await http.MultipartFile.fromPath('profileImage', _selectedImage!.path));
  }

  // إرسال الطلب
  var response = await request.send();

var responseString = await response.stream.bytesToString();

if (response.statusCode == 200) {
  print("✅ Update successful");
  print("Response: $responseString");
} else {
  print("❌ Failed with status: ${response.statusCode}");
  print("Response: $responseString");
}

  if (response.statusCode == 200) {
    // رجع للصفحة السابقة أو أظهر رسالة نجاح
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Profile updated successfully")),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Failed to update profile")),
    );
  }
}


  void _showMessage(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        content: Text(msg),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: const Color(0xFF8DBF67),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : const AssetImage('assets/images/default_avatar.png') as ImageProvider,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.camera_alt, color: Color(0xFF8DBF67)),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password (optional)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8DBF67),
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: const Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}
