import 'package:flutter/material.dart';
import 'edit_profile_page.dart';
import 'change_password_page.dart';
import 'login_page.dart'; 
//import 'main_home_section.dart';
//import 'main_section.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, size: 50, color: Colors.green),
            const SizedBox(height: 10),
            const Text("tasneem@gmail.com", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Profile'),
              onTap: () {
                Navigator.pop(context); // نغلق النافذة
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const EditProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock),
              title: const Text('Change Password'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChangePasswordPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F8F4),
      appBar: AppBar(
        title: const Text("🌿 Plantsi"),
        backgroundColor: const Color(0xFF8DBF67),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // 👉 رح نضيف صفحة السلة لاحقاً
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => _showProfileMenu(context),
          ),
        ],
      ),
     body: const SingleChildScrollView(
child: Center(child: Text("Placeholder")),
),

    );
  }
}
