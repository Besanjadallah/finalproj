import 'package:flutter/material.dart';

class ViewUsersPage extends StatefulWidget {
  const ViewUsersPage({super.key});

  @override
  State<ViewUsersPage> createState() => _ViewUsersPageState();
}

class _ViewUsersPageState extends State<ViewUsersPage> {
  List<Map<String, dynamic>> users = [
    {
      'name': 'Sara Khalil',
      'email': 'sara@gmail.com',
      'phone': '0599112233',
      'address': 'Hebron - City Center',

      'purchases': {'Green Garden': 55, 'EcoPlants': 45},

    },
    {
      'name': 'Omar Taha',
      'email': 'omar@hotmail.com',
      'phone': '0599776655',
      'address': 'Jericho - Al-Quds St.',

      'purchases': {'Green Garden': 30, 'EcoPlants': 70},

    },
    {
      'name': 'Hiba Awad',
      'email': 'hiba@outlook.com',
      'phone': '0599001122',
      'address': 'Tulkarm - Al-Madina St.',

      'purchases': {'Green Garden': 80, 'EcoPlants': 20},

    },
  ];

  void _deleteUser(int index) {
    setState(() {
      users.removeAt(index);
    });
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: IntrinsicHeight(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                    width: constraints.maxWidth,
                    padding: const EdgeInsets.all(16),
                    child: DataTable(

                      headingRowColor: MaterialStateProperty.all(
                        const Color(0xFFE2E8CE),
                      ),
                      dataRowHeight: 80,
                      headingRowHeight: 60,
                      columnSpacing: 36,
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columns: const [
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Address')),
                        DataColumn(label: Text('Purchases')),
                        DataColumn(label: Text('Delete')),
                      ],
                      rows: List.generate(users.length, (index) {
                        final user = users[index];
                        return DataRow(
                          cells: [
                            DataCell(Text(user['name'])),
                            DataCell(Text(user['email'])),
                            DataCell(Text(user['phone'])),
                            DataCell(Text(user['address'])),
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                    (user['purchases'] as Map<String, int>)
                                        .entries
                                        .map(
                                          (e) => Text('${e.key}: ${e.value}%'),
                                        )
                                        .toList(),
                              ),
                            ),
                            DataCell(
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteUser(index),
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
