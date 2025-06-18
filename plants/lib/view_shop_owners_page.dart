import 'package:flutter/material.dart';

class ViewShopOwnersPage extends StatefulWidget {
  const ViewShopOwnersPage({super.key});

  @override
  State<ViewShopOwnersPage> createState() => _ViewShopOwnersPageState();
}

class _ViewShopOwnersPageState extends State<ViewShopOwnersPage> {
  List<Map<String, String>> owners = [
    {
      'name': 'Ahmad Taha',
      'email': 'ahmad@gmail.com',
      'phone': '0599112233',
      'address': 'Nablus - Al-Makhfiya',
    },
    {
      'name': 'Lina Awad',
      'email': 'lina@hotmail.com',
      'phone': '0599776655',
      'address': 'Ramallah - Al-Tira',
    },
    {
      'name': 'Sarah Rami',
      'email': 'sarah@outlook.com',
      'phone': '0599001122',
      'address': 'Hebron - City Center',
    },
    {
      'name': 'Ahmad Taha',
      'email': 'ahmad@gmail.com',
      'phone': '0599112233',
      'address': 'Nablus - Al-Makhfiya',
    },
    {
      'name': 'Lina Awad',
      'email': 'lina@hotmail.com',
      'phone': '0599776655',
      'address': 'Ramallah - Al-Tira',
    },
    {
      'name': 'Sarah Rami',
      'email': 'sarah@outlook.com',
      'phone': '0599001122',
      'address': 'Hebron - City Center',
    },
    {
      'name': 'Ahmad Taha',
      'email': 'ahmad@gmail.com',
      'phone': '0599112233',
      'address': 'Nablus - Al-Makhfiya',
    },
    {
      'name': 'Lina Awad',
      'email': 'lina@hotmail.com',
      'phone': '0599776655',
      'address': 'Ramallah - Al-Tira',
    },
    {
      'name': 'Sarah Rami',
      'email': 'sarah@outlook.com',
      'phone': '0599001122',
      'address': 'Hebron - City Center',
    },

  ];

  void _deleteOwner(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Owner'),
        content: const Text(
          'Are you sure you want to delete this shop owner?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                owners.removeAt(index);
              });
              Navigator.pop(context);
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

  void _startChatWithOwner(String ownerName) {
    // TODO: Implement chat functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Chat with $ownerName will be implemented soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EE),
      appBar: AppBar(
        title: const Text('Shop Owners'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6D9773),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

                crossAxisCount:
                    constraints.maxWidth > 900
                        ? 3
                        : constraints.maxWidth > 600
                        ? 2
                        : 1,

                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.6,
              ),
              itemCount: owners.length,
              itemBuilder: (context, index) {
                final owner = owners[index];
                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.person, color: Color(0xFF6D9773)),
                            const SizedBox(width: 8),

                            Flexible(

                              child: Text(
                                owner['name']!,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            IconButton(
                              icon: const Icon(Icons.chat_bubble_outline, color: Colors.blueGrey),
                              tooltip: 'Chat with owner',
                              onPressed: () => _startChatWithOwner(owner['name']!),
                            ),

                          ],
                        ),
                        Row(
                          children: [

                            const Icon(
                              Icons.email,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Flexible(child: Text(owner['email']!)),

                          ],
                        ),
                        Row(
                          children: [

                            const Icon(
                              Icons.phone,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Flexible(child: Text(owner['phone']!)),
                          ],
                        ),
                        Row(
                          children: [

                            const Icon(
                              Icons.location_on,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Flexible(child: Text(owner['address']!)),

                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),

                            tooltip: 'Delete owner',

                            onPressed: () => _deleteOwner(index),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
//
// class ViewShopOwnersPage extends StatefulWidget {
//   const ViewShopOwnersPage({super.key});
//
//   @override
//   State<ViewShopOwnersPage> createState() => _ViewShopOwnersPageState();
// }
//
// class _ViewShopOwnersPageState extends State<ViewShopOwnersPage> {
//   List<Map<String, String>> owners = [
//     {
//       'name': 'Ahmad Taha',
//       'email': 'ahmad@gmail.com',
//       'phone': '0599112233',
//       'address': 'Nablus - Al-Makhfiya',
//     },
//     {
//       'name': 'Lina Awad',
//       'email': 'lina@hotmail.com',
//       'phone': '0599776655',
//       'address': 'Ramallah - Al-Tira',
//     },
//     {
//       'name': 'Sarah Rami',
//       'email': 'sarah@outlook.com',
//       'phone': '0599001122',
//       'address': 'Hebron - City Center',
//     },
//     {
//       'name': 'Ahmad Taha',
//       'email': 'ahmad@gmail.com',
//       'phone': '0599112233',
//       'address': 'Nablus - Al-Makhfiya',
//     },
//     {
//       'name': 'Lina Awad',
//       'email': 'lina@hotmail.com',
//       'phone': '0599776655',
//       'address': 'Ramallah - Al-Tira',
//     },
//     {
//       'name': 'Sarah Rami',
//       'email': 'sarah@outlook.com',
//       'phone': '0599001122',
//       'address': 'Hebron - City Center',
//     },
//     {
//       'name': 'Ahmad Taha',
//       'email': 'ahmad@gmail.com',
//       'phone': '0599112233',
//       'address': 'Nablus - Al-Makhfiya',
//     },
//     {
//       'name': 'Lina Awad',
//       'email': 'lina@hotmail.com',
//       'phone': '0599776655',
//       'address': 'Ramallah - Al-Tira',
//     },
//     {
//       'name': 'Sarah Rami',
//       'email': 'sarah@outlook.com',
//       'phone': '0599001122',
//       'address': 'Hebron - City Center',
//     },
//   ];
//
//   void _deleteOwner(int index) {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Delete Owner'),
//         content: const Text('Are you sure you want to delete this shop owner?'),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 owners.removeAt(index);
//               });
//               Navigator.pop(context);
//             },
//             child: const Text('Delete', style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F1EE),
//       appBar: AppBar(
//         title: const Text('Shop Owners'),
//         centerTitle: true,
//         backgroundColor: const Color(0xFF6D9773),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: LayoutBuilder(
//           builder: (context, constraints) {
//             return GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: constraints.maxWidth > 900
//                     ? 3
//                     : constraints.maxWidth > 600
//                     ? 2
//                     : 1,
//                 crossAxisSpacing: 16,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 1.6,
//               ),
//               itemCount: owners.length,
//               itemBuilder: (context, index) {
//                 final owner = owners[index];
//                 return Card(
//                   elevation: 4,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             const Icon(Icons.person, color: Color(0xFF6D9773)),
//                             const SizedBox(width: 8),
//                             Flexible(
//                               child: Text(
//                                 owner['name']!,
//                                 style: const TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Icon(Icons.email, size: 18, color: Colors.grey),
//                             const SizedBox(width: 8),
//                             Flexible(child: Text(owner['email']!)),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Icon(Icons.phone, size: 18, color: Colors.grey),
//                             const SizedBox(width: 8),
//                             Flexible(child: Text(owner['phone']!)),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Icon(Icons.location_on, size: 18, color: Colors.grey),
//                             const SizedBox(width: 8),
//                             Flexible(child: Text(owner['address']!)),
//                           ],
//                         ),
//                         Align(
//                           alignment: Alignment.bottomRight,
//                           child: IconButton(
//                             icon: const Icon(Icons.delete, color: Colors.red),
//                             onPressed: () => _deleteOwner(index),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

