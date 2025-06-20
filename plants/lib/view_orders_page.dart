import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewOrdersPage extends StatefulWidget {
  const ViewOrdersPage({super.key});

  @override
  State<ViewOrdersPage> createState() => _ViewOrdersPageState();
}

class _ViewOrdersPageState extends State<ViewOrdersPage> {
  late Future<List<dynamic>> _ordersFuture;
  List<dynamic> _allOrders = [];

  String _searchQuery = '';
  String _filterStatus = 'All';

  @override
  void initState() {
    super.initState();
    _ordersFuture = fetchOrders();
  }

  Future<List<dynamic>> fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userId = prefs.getString('userId');

    final url = Uri.parse('http://192.168.1.18:8080/api/orders/$userId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _allOrders = data;
      });
      return data;
    } else {
      print("❌ Failed to fetch orders: ${response.statusCode}");
      return [];
    }
  }

  List<dynamic> get _filteredOrders {
    return _allOrders.where((order) {
      final matchesStatus = _filterStatus == 'All' || order['status'] == _filterStatus;
      final matchesSearch = _searchQuery.isEmpty ||
          order['orderId'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order['customerName'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order['productName'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  void _toggleOrderStatus(int index) {
    setState(() {
      final order = _filteredOrders[index];
      final newStatus = order['status'] == 'Pending' ? 'Shipped' : 'Pending';
      order['status'] = newStatus;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Order ${order['orderId']} marked as $newStatus.'),
          backgroundColor: newStatus == 'Shipped' ? Colors.green : Colors.orange,
        ),
      );
    });
  }

  void _deleteOrder(int index) {
    final orderId = _filteredOrders[index]['orderId'];
    setState(() {
      _allOrders.removeWhere((order) => order['orderId'] == orderId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order $orderId has been deleted.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Order Details (${order['orderId']})'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Customer: ${order['customerName']}'),
            Text('Product: ${order['productName']}'),
            Text('Quantity: ${order['quantity']}'),
            Text('Price: ₪${order['price'].toStringAsFixed(2)}'),
            Text('Status: ${order['status']}'),
            Text('Date: ${order['date']}'),
            Text('Address: ${order['address']}'),
            Text('Phone: ${order['phone']}'),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.orange;
      case 'Shipped':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: const Color(0xFF8DBF67),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || _filteredOrders.isEmpty) {
            return const Center(child: Text('No orders found.'));
          }

          return Column(
            children: [
              // 🔍 Search
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search...',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),

              // 🧠 Filter chips
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['All', 'Pending', 'Shipped'].map((status) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: ChoiceChip(
                      label: Text(status),
                      selected: _filterStatus == status,
                      selectedColor: const Color(0xFF8DBF67),
                      backgroundColor: Colors.grey.shade300,
                      labelStyle: TextStyle(
                        color: _filterStatus == status ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      onSelected: (_) {
                        setState(() {
                          _filterStatus = status;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 10),

              // 📝 Orders list
              Expanded(
                child: ListView.builder(
                  itemCount: _filteredOrders.length,
                  itemBuilder: (context, index) {
                    final order = _filteredOrders[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: _getStatusColor(order['status']),
                          child: Text(order['orderId'].substring(order['orderId'].length - 3)),
                        ),
                        title: Text('${order['productName']} x${order['quantity']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Customer: ${order['customerName']}'),
                            Text('₪${order['price'].toStringAsFixed(2)} - ${order['status']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.info, color: Colors.blue),
                              onPressed: () => _showOrderDetails(order),
                            ),
                            IconButton(
                              icon: const Icon(Icons.swap_horiz, color: Colors.orange),
                              onPressed: () => _toggleOrderStatus(index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteOrder(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
