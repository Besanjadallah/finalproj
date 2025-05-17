import 'package:flutter/material.dart';
import 'add_product_page.dart';
import 'edit_products_page.dart';
import 'delete_product_page.dart';
import 'view_orders_page.dart';
import 'manage_users_page.dart';
import 'login_page.dart'; // إذا بدك ترجعي للّوجن عند تسجيل الخروج

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8DBF67),
        elevation: 0,
        title: const Text('Admin Dashboard'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          children: [
            _buildAdminOption(
              icon: Icons.add_box_rounded,
              label: 'Add Product',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddProductPage()),
                );
              },
            ),
            _buildAdminOption(
              icon: Icons.edit_note_rounded,
              label: 'Edit Products',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProductsPage()),
                );
              },
            ),
            _buildAdminOption(
              icon: Icons.delete_forever,
              label: 'Delete Product',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DeleteProductPage()),
                );
              },
            ),
            _buildAdminOption(
              icon: Icons.receipt_long,
              label: 'Orders',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ViewOrdersPage()),
                );
              },
            ),
            _buildAdminOption(
              icon: Icons.people_alt_rounded,
              label: 'Users',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ManageUsersPage()),
                );
              },
            ),
            _buildAdminOption(
              icon: Icons.logout,
              label: 'Logout',
              onTap: () {
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

  Widget _buildAdminOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.green),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
