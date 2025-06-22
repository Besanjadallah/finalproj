import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String apiBaseUrl = 'http://192.168.56.1:8080'; // بدلي IP لو بدك

class ViewUsersPage extends StatefulWidget {
  const ViewUsersPage({super.key});

  @override
  State<ViewUsersPage> createState() => _ViewUsersPageState();
}

class _ViewUsersPageState extends State<ViewUsersPage> {
  final dio = Dio();
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return;

    try {
      final response = await dio.get(
        '$apiBaseUrl/api/users/normal',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final data = response.data as List;

      setState(() {
        users =
            data
                .where((user) => user['role'] == 'user')
                .map(
                  (user) => {
                    'id': user['_id'],
                    'name': user['name'],
                    'email': user['email'],
                    'phone': user['phone'],
                    'address': user['address'],
                  },
                )
                .toList();
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
  }

  Future<void> _deleteUser(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final userId = users[index]['id'];

    try {
      await dio.delete(
        '$apiBaseUrl/api/users/$userId',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      setState(() {
        users.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User deleted successfully!')),
      );
    } catch (e) {
      print('Error deleting user: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to delete user')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EE),
      appBar: AppBar(
        title: const Text("All Users"),
        backgroundColor: const Color(0xFF6D9773),
        centerTitle: true,
      ),
      body:
          users.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.person,
                        color: Color(0xFF6D9773),
                      ),
                      title: Text(user['name']),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${user['email']}'),
                          Text('Phone: ${user['phone']}'),
                          Text('Address: ${user['address']}'),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteUser(index),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
