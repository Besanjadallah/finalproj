<<<<<<< HEAD
=======
//

>>>>>>> tasneem-upload
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
<<<<<<< HEAD
import 'profile_page.dart';
import 'signup_page.dart';
import 'admin_dashboard.dart';
import 'package:flutter/foundation.dart';
import 'main_home_page.dart';
=======
//import 'profile_page.dart';
import 'signup_page.dart';
import 'admin_dashboard.dart';
//import 'shop_owner_dashboard.dart';
import 'main_home_page.dart';
import 'owner.dart';

const String apiBaseUrl = 'http://192.168.56.1:8080'; // Use your backend IP and port
>>>>>>> tasneem-upload

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> loginUser() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      showDialog(
        context: context,
<<<<<<< HEAD
        builder: (_) => AlertDialog(
          title: const Text("Missing Info"),
          content: const Text("Please fill in all fields."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
=======
        builder:
            (_) => AlertDialog(
              title: const Text("Missing Info"),
              content: const Text("Please fill in all fields."),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
>>>>>>> tasneem-upload
      );
      return;
    }

    try {
      print("📤 Sending login request...");
      final response = await http.post(
<<<<<<< HEAD
        Uri.parse('http://192.168.1.86:8080/api/users/login'),
=======
        Uri.parse('http://192.168.56.1:8080/api/users/login'),
>>>>>>> tasneem-upload
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print("📥 Raw response: ${response.body}");
      final data = jsonDecode(response.body);

      print("📬 Response status: ${response.statusCode}");
      print("📬 Response data: $data");

      if (response.statusCode == 200) {
<<<<<<< HEAD
=======

>>>>>>> tasneem-upload
        print("✅ Login success");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('role', data['user']['role']);
        await prefs.setString('name', data['user']['name']);
        await prefs.setString('email', data['user']['email']);
<<<<<<< HEAD
        await prefs.setString('userId', data['user']['id']); // 🟢 خزني userId الحقيقي
        


        if (!mounted) return;

=======

        if (!mounted) return;

        // التوجيه حسب نوع المستخدم
>>>>>>> tasneem-upload
        if (data['user']['role'] == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboard()),
          );
<<<<<<< HEAD
=======
        } else if (data['user']['role'] == 'shopowner') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const ShopOwnerDashboard()),
          );

>>>>>>> tasneem-upload
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainHomePage()),
          );
        }
      } else {
        print("⚠️ Login failed: ${data['error'] ?? data['message']}");
        showDialog(
          context: context,
<<<<<<< HEAD
          builder: (_) => AlertDialog(
            title: const Text("Error"),
            content: Text(data['error'] ?? data['message'] ?? "Invalid credentials."),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
=======

          builder:
              (_) => AlertDialog(
                title: const Text("Error"),
                content: Text(data['message'] ?? "Invalid email or password."),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("OK"),
                  ),
                ],

              ),
>>>>>>> tasneem-upload
        );
      }
    } catch (e) {
      print("❌ Exception during login: $e");
      showDialog(
        context: context,
<<<<<<< HEAD
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text('Failed to connect to server.\n$e'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
=======
        builder:
            (_) => AlertDialog(
              title: const Text("Error"),
              content: Text('Failed to connect to server.\n$e'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                ),
              ],
            ),
>>>>>>> tasneem-upload
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Image.asset(
                'assets/images/bg.jpg',
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              'Sign in',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email, color: Colors.green),
                  hintText: 'Email',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, color: Colors.green),
                  hintText: 'Password',
                  filled: true,
                  fillColor: Colors.grey.shade200,
                  contentPadding: const EdgeInsets.symmetric(vertical: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loginUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8DBF67),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Get started',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
              child: const Text.rich(
                TextSpan(
                  text: 'Don\'t have an account? ',
                  style: TextStyle(color: Colors.black54),
                  children: [
                    TextSpan(
                      text: 'Sign up',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
<<<<<<< HEAD
                    )
=======
                    ),
>>>>>>> tasneem-upload
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
