import 'package:flutter/material.dart';

import 'package:plants/view_shop_owners_page.dart';
import 'package:plants/view_shops_page.dart';
import 'package:plants/view_users_page.dart';
// import 'add_shop_owner_page.dart';
 import 'AdminInsightsPage.dart';
import 'add_shop_owner_page.dart';
import 'add_shop_page.dart';
// import 'view_shop_owners_page.dart';
// import 'search_page.dart';
// import 'delete_account_page.dart';
import 'login_page.dart';
import 'profile_page.dart';

import 'add_product_page.dart';
import 'edit_products_page.dart';
import 'delete_product_page.dart';
import 'view_orders_page.dart';
import 'manage_users_page.dart';
import 'login_page.dart'; 


class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EE), // خلفية ناعمة
      appBar: AppBar(
        backgroundColor: const Color(0xFF6D9773), // لون زيتوني
        elevation: 0,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle_rounded, size: 28),
            tooltip: 'My Account',
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => const ProfilePage()),
              // );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const SizedBox(height: 16),
            // _buildOptionTile(
            //   icon: Icons.search,
            //   label: 'Search',
            //   onTap: () {
            //     // Navigator.push(context,
            //     //     MaterialPageRoute(builder: (_) => const SearchPage()));
            //   },
            // ),
            _buildOptionTile(
              icon: Icons.person_add_alt_1,
              label: 'Add Shop Owner',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const AddShopOwnerPage()));
              },
            ),
            _buildOptionTile(
              icon: Icons.view_list_rounded,
              label: 'View Users',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ViewUsersPage()));
              },
            ),
            _buildOptionTile(
              icon: Icons.view_list_rounded,
              label: ' View shop',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ViewShopsPage()));
              },
            ),
            _buildOptionTile(
              icon: Icons.view_list_rounded,
              label: 'View Shop Owners',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ViewShopOwnersPage()));
              },
            ),
            _buildOptionTile(
              icon: Icons.image_aspect_ratio_outlined,
              label: 'Sales ratio',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (_) => AdminInsightsPage()));
              },
            ),
            _buildOptionTile(
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

  Widget _buildOptionTile({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(icon, size: 32, color: const Color(0xFF6D9773)),
        title: Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF333333),
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 20),
        onTap: onTap,
      ),
    );
  }
}
