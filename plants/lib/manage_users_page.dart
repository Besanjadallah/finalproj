import 'package:flutter/material.dart';
import 'admin_dashboard.dart';

class ManageUsersPage extends StatefulWidget {
  const ManageUsersPage({super.key});

  @override
  State<ManageUsersPage> createState() => _ManageUsersPageState();
}

class _ManageUsersPageState extends State<ManageUsersPage> {
  // بيانات المستخدمين نموذجية (لاحقاً تجي من backend)
  List<Map<String, dynamic>> users = [
    {
      'userId': 'U001',
      'name': 'Alice Johnson',
      'email': 'alice@example.com',
      'role': 'Admin',
      'phone': '+1234567890',
    },
    {
      'userId': 'U002',
      'name': 'Bob Smith',
      'email': 'bob@example.com',
      'role': 'User',
      'phone': '+0987654321',
    },
    {
      'userId': 'U003',
      'name': 'Charlie Brown',
      'email': 'charlie@example.com',
      'role': 'User',
      'phone': '+1122334455',
    },
  ];

  String _searchQuery = '';

  // تحديث بيانات المستخدم (مثلاً تعديل الدور)
  void _editUser(int index) {
    TextEditingController roleController = TextEditingController(text: users[index]['role']);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit User Role (${users[index]['name']})'),
        content: TextField(
          controller: roleController,
          decoration: const InputDecoration(labelText: 'Role (Admin/User)'),
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              setState(() {
                users[index]['role'] = roleController.text.trim();
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('User role updated successfully')),
              );
            },
          ),
        ],
      ),
    );
  }

  // حذف المستخدم
  void _deleteUser(int index) {
    String deletedUserName = users[index]['name'];
    setState(() {
      users.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('User $deletedUserName has been deleted.'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // البحث عن المستخدمين
  List<Map<String, dynamic>> get _filteredUsers {
    return users.where((user) {
      final query = _searchQuery.toLowerCase();
      return user['name'].toLowerCase().contains(query) ||
          user['email'].toLowerCase().contains(query) ||
          user['role'].toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF8DBF67),
        title: const Text('Manage Users'),
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
                hintText: 'Search users...',
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
            const SizedBox(height: 15),
            // قائمة المستخدمين
            Expanded(
              child: _filteredUsers.isEmpty
                  ? const Center(
                      child: Text(
                        'No users found.',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredUsers.length,
                      itemBuilder: (context, index) {
                        final user = _filteredUsers[index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(20),
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.shade700,
                              child: Text(
                                user['name'][0].toUpperCase(),
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                            ),
                            title: Text(
                              user['name'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Email: ${user['email']}'),
                                Text('Role: ${user['role']}'),
                                Text('Phone: ${user['phone']}'),
                              ],
                            ),
                            trailing: SizedBox(
                              width: 110,
                              child: Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Edit User',
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () => _editUser(users.indexOf(user)),
                                  ),
                                  IconButton(
                                    tooltip: 'Delete User',
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text('Confirm Deletion'),
                                          content: Text('Are you sure you want to delete user ${user['name']}?'),
                                          actions: [
                                            TextButton(
                                              child: const Text('Cancel'),
                                              onPressed: () => Navigator.pop(context),
                                            ),
                                            TextButton(
                                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deleteUser(users.indexOf(user));
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
