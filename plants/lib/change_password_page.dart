import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future<void> _changePassword() async {
    print("🟢 Change password clicked");

    final oldPass = _oldPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty) {
      _showMessage("Please fill in both fields.");
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse('http://192.168.1.86:8080/api/users/change-password'); // 🎯 غيّري الـ IP إذا لزم
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'currentPassword': oldPass,
        'newPassword': newPass,
      }),
    );

    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");

    if (response.statusCode == 200) {
      _showMessage("✅ Password changed successfully!");
      Navigator.pop(context); // رجوع لصفحة البروفايل
    } else {
      final data = jsonDecode(response.body);
      _showMessage(data['error'] ?? data['message'] ?? "❌ Failed to change password.");
    }
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
        backgroundColor: const Color(0xFF8DBF67),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _oldPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _changePassword,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8DBF67),
              ),
              child: const Text('Update Password'),
            ),
          ],
        ),
      ),
    );
  }
}
