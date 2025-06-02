import 'package:flutter/material.dart';
import 'admin_dashboard.dart';

class DeleteProductPage extends StatefulWidget {
  const DeleteProductPage({super.key});

  @override
  State<DeleteProductPage> createState() => _DeleteProductPageState();
}

class _DeleteProductPageState extends State<DeleteProductPage> {
  List<Map<String, String>> products = [
    {'name': 'Aloe Vera', 'price': '10.99', 'description': 'A healing succulent plant.'},
    {'name': 'Peace Lily', 'price': '14.50', 'description': 'A beautiful flowering indoor plant.'},
    {'name': 'Snake Plant', 'price': '8.99', 'description': 'Low maintenance air-purifying plant.'},
  ];

  List<Map<String, String>> filteredProducts = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredProducts = List.from(products); // Initial display
    _searchController.addListener(_filterProducts);
  }

  void _filterProducts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredProducts = products
          .where((product) => product['name']!.toLowerCase().contains(query))
          .toList();
    });
  }

  void _deleteProduct(int index) {
    setState(() {
      final originalIndex = products.indexOf(filteredProducts[index]);
      products.removeAt(originalIndex);
      _filterProducts(); // reapply filter after delete
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Product deleted successfully'),
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  void _confirmDelete(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete "${filteredProducts[index]['name']}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteProduct(index);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8DBF67),
        title: const Text('Delete Products'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const AdminDashboard()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSearchField(),
            const SizedBox(height: 20),
            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(
                      child: Text(
                        'No matching products found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16),
                            leading: const Icon(Icons.local_florist, color: Colors.green, size: 32),
                            title: Text(
                              product['name']!,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Text("Price: \$${product['price']}"),
                                const SizedBox(height: 4),
                                Text("Description: ${product['description']}"),
                              ],
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_forever, color: Colors.red, size: 28),
                              onPressed: () => _confirmDelete(index),
                              tooltip: 'Delete Product',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search, color: Colors.green),
        hintText: 'Search by product name',
        filled: true,
        fillColor: Colors.grey.shade200,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
