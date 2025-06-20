import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'profile_page.dart';
import 'edit_profile_page.dart';
import 'main_home_page.dart';

const String apiBaseUrl =
    'http://192.168.56.1:8080'; // Use your backend IP and port

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> registerUser() async {
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showDialog(
        context: context,
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
      );
      return;
    }

    try {
      final dio = Dio();
      final response = await dio.post(
        '$apiBaseUrl/api/users/register',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          'name': fullNameController.text,
          'email': emailController.text,
          'phone': phoneController.text,
          'address': addressController.text,
          'password': passwordController.text,
          'role': 'user',
        },
      );

      final resData = response.data;

      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', resData['token']);
        await prefs.setString('role', resData['user']['role']);

        if (!mounted) return;
        showDialog(
          context: context,
          builder:
              (_) => AlertDialog(
                title: const Text("Registration Successful"),
                content: const Text(
                  "Your account has been created successfully!",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const MainHomePage()),
                      );
                    },
                    child: const Text("OK"),
                  ),
                ],
              ),
        );
      } else {
        showErrorDialog(resData['message'] ?? 'Something went wrong');
      }
    } catch (e) {
      showErrorDialog('Failed to connect to server.\n$e');
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color softGreen = const Color(0xFFDDEED4);

    return Scaffold(
      backgroundColor: softGreen,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
              child: Image.asset(
                'assets/images/bg.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Create Account 🌱',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please fill the form to continue',
              style: TextStyle(fontSize: 15, color: Colors.black54),
            ),
            const SizedBox(height: 25),

            // Full Name
            customField(
              controller: fullNameController,
              hint: 'Full Name',
              icon: Icons.person,
            ),

            // Email
            customField(
              controller: emailController,
              hint: 'Email',
              icon: Icons.email,
            ),

            // Phone
            customField(
              controller: phoneController,
              hint: 'Phone Number',
              icon: Icons.phone,
            ),

            // Address
            customField(
              controller: addressController,
              hint: 'Address',
              icon: Icons.location_on,
            ),

            // Password
            customField(
              controller: passwordController,
              hint: 'Password',
              icon: Icons.lock,
              isPassword: true,
            ),

            const SizedBox(height: 30),

            // زر التسجيل
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: registerUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8DBF67),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 18)),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget customField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.green),
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
