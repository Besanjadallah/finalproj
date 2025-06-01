import 'package:flutter/material.dart';

class ShopOwnerDashboard extends StatelessWidget {
  const ShopOwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final Color background = const Color(0xFFF4F1EE);
    final Color cardColor = const Color(0xFFDDEED4);

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        title: const Text('Shop Owner Panel 🌿'),
        backgroundColor: const Color(0xFF6D9773),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _buildCard(context, Icons.local_florist, 'Manage Plants'),
          _buildCard(context, Icons.shopping_cart, 'Orders'),
          _buildCard(context, Icons.bar_chart, 'Sales Stats'),
          _buildCard(context, Icons.people, 'Customers'),
          _buildCard(context, Icons.comment, 'Reviews'),
          _buildCard(context, Icons.settings, 'Settings'),
        ],
      ),
    );
  }

  Widget _buildCard(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        // navigate to proper page later
      },
      child: Card(
        elevation: 4,
        color: const Color(0xFFDDEED4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: const Color(0xFF46624A)),
              const SizedBox(height: 10),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
