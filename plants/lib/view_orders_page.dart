import 'package:flutter/material.dart';
import 'admin_dashboard.dart';

class ViewOrdersPage extends StatefulWidget {
  const ViewOrdersPage({super.key});

  @override
  State<ViewOrdersPage> createState() => _ViewOrdersPageState();
}

class _ViewOrdersPageState extends State<ViewOrdersPage> {
  // بيانات الطلبات نموذجية مع تفاصيل إضافية
  List<Map<String, dynamic>> orders = [
    {
      'orderId': 'ORD001',
      'customerName': 'Alice',
      'productName': 'Aloe Vera',
      'quantity': 2,
      'price': 21.98,
      'status': 'Pending',
      'date': '2025-05-10',
      'address': '123 Green St, Plant City',
      'phone': '+1234567890',
    },
    {
      'orderId': 'ORD002',
      'customerName': 'Bob',
      'productName': 'Peace Lily',
      'quantity': 1,
      'price': 14.50,
      'status': 'Shipped',
      'date': '2025-05-12',
      'address': '456 Flower Rd, Garden Town',
      'phone': '+0987654321',
    },
    {
      'orderId': 'ORD003',
      'customerName': 'Charlie',
      'productName': 'Snake Plant',
      'quantity': 3,
      'price': 26.97,
      'status': 'Pending',
      'date': '2025-05-13',
      'address': '789 Leaf Ave, Nature City',
      'phone': '+1122334455',
    },
  ];

  String _searchQuery = '';
  String _filterStatus = 'All';

  // تغيير حالة الطلب بين Pending و Shipped
  void _toggleOrderStatus(int index) {
    setState(() {
      if (orders[index]['status'] == 'Pending') {
        orders[index]['status'] = 'Shipped';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order ${orders[index]['orderId']} marked as Shipped.'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        orders[index]['status'] = 'Pending';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Order ${orders[index]['orderId']} marked as Pending.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  // حذف الطلب
  void _deleteOrder(int index) {
    String deletedOrderId = orders[index]['orderId'];
    setState(() {
      orders.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order $deletedOrderId has been deleted.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // لون الحالة حسب نوعها
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Shipped':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  // تصفية الطلبات بناء على البحث والحالة
  List<Map<String, dynamic>> get _filteredOrders {
    return orders.where((order) {
      final matchesStatus = _filterStatus == 'All' || order['status'] == _filterStatus;
      final matchesSearch = _searchQuery.isEmpty ||
          order['orderId'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order['customerName'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
          order['productName'].toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  // نافذة تفاصيل الطلب
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
            Text('Price: \$${order['price'].toStringAsFixed(2)}'),
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
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8DBF67),
        title: const Text('View Orders'),
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
            // مربع البحث
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search, color: Colors.green),
                hintText: 'Search orders...',
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 10),
            // فلترة الحالة
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: ['All', 'Pending', 'Shipped'].map((status) {
                bool isSelected = _filterStatus == status;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: isSelected,
                    selectedColor: const Color(0xFF8DBF67),
                    backgroundColor: Colors.grey.shade300,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
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
            const SizedBox(height: 15),
            // قائمة الطلبات
            Expanded(
              child: _filteredOrders.isEmpty
                  ? const Center(
                      child: Text(
                        'No orders found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = _filteredOrders[index];
                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(20),
                            leading: CircleAvatar(
                              backgroundColor: _getStatusColor(order['status']),
                              child: Text(
                                order['orderId'].substring(order['orderId'].length - 3),
                                style: const TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              '${order['productName']} x${order['quantity']}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Customer: ${order['customerName']}'),
                                Text('Total Price: \$${order['price'].toStringAsFixed(2)}'),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    const Text(
                                      'Status: ',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      order['status'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: _getStatusColor(order['status']),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            trailing: SizedBox(
                              width: 120,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // زر عرض التفاصيل
                                  IconButton(
                                    tooltip: 'View Details',
                                    icon: const Icon(Icons.info, color: Colors.blue),
                                    onPressed: () => _showOrderDetails(order),
                                  ),
                                  // زر تغيير الحالة
                                  ElevatedButton(
                                    onPressed: () => _toggleOrderStatus(orders.indexOf(order)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          order['status'] == 'Pending' ? Colors.green : Colors.orange,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      order['status'] == 'Pending'
                                          ? 'Mark Shipped'
                                          : 'Mark Pending',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                  // زر حذف الطلب
                                  IconButton(
                                    tooltip: 'Delete Order',
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: Text(
                                              'Are you sure you want to delete order ${order['orderId']}?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                            TextButton(
                                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deleteOrder(orders.indexOf(order));
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
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
}
