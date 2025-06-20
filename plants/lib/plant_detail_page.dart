import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../providers/cart_provider.dart';

class PlantDetailPage extends StatelessWidget {
  final String id; // ✅ ObjectId from MongoDB
  final String imagePath;
  final String name;
  final String temperature;
  final String lighting;
  final String watering;
  final double price;

  const PlantDetailPage({
    super.key,
    required this.id,
    required this.imagePath,
    required this.name,
    required this.temperature,
    required this.lighting,
    required this.watering,
    required this.price,
  });

  void openWikipedia(String plantName) async {
    final url = "https://en.wikipedia.org/wiki/${Uri.encodeComponent(plantName)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch Wikipedia';
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8DBF67),
        title: Text(name, style: const TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(imagePath, height: 200, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Text("🌡️ Temperature: $temperature", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("☀️ Lighting: $lighting", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("💧 Watering: $watering", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text("💲 Price: ₪${price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => openWikipedia(name),
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text("Wikipedia"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8DBF67),
                    foregroundColor: Colors.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    cartProvider.addItem(id, name, price, imagePath);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("🛒 Added to cart!")),
                    );
                  },
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text("Add to Cart"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8DBF67),
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
