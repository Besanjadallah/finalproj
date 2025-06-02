import 'package:flutter/material.dart';

class ViewShopsPage extends StatefulWidget {
  const ViewShopsPage({super.key});

  @override
  State<ViewShopsPage> createState() => _ViewShopsPageState();
}

class _ViewShopsPageState extends State<ViewShopsPage> {
  final List<Map<String, String>> shops = [
    {'shopName': 'Green Garden', 'ownerName': 'Ahmad Taha'},
    {'shopName': 'EcoPlants', 'ownerName': 'Lina Awad'},
    {'shopName': 'My Cactus', 'ownerName': 'Sarah Rami'},
    {'shopName': 'Flower Spot', 'ownerName': 'Omar Salah'},
    {'shopName': 'Succulent House', 'ownerName': 'Mona Shaker'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1EE),
      appBar: AppBar(
        title: const Text('All Shops'),
        centerTitle: true,
        backgroundColor: const Color(0xFF6D9773),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: constraints.maxWidth > 900
                    ? 3
                    : constraints.maxWidth > 600
                    ? 2
                    : 1,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1.8,
              ),
              itemCount: shops.length,
              itemBuilder: (context, index) {
                final shop = shops[index];
                return Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.storefront,
                                color: Color(0xFF6D9773), size: 28),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                shop['shopName']!,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF344E41),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.person_outline,
                                color: Colors.grey, size: 22),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                shop['ownerName']!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
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
