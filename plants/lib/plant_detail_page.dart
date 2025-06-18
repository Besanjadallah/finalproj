import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PlantDetailPage extends StatelessWidget {
  final String imagePath;
  final String name;
  final String temperature;
  final String lighting;
  final String watering;
  final double price;

  const PlantDetailPage({
    super.key,
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
            Center(
              child: ElevatedButton.icon(
                onPressed: () => openWikipedia(name),
                icon: const Icon(Icons.auto_awesome),
                label: const Text("More Information (Wikipedia)"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8DBF67),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
