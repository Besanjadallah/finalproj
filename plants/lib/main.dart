import 'package:flutter/material.dart';
import 'welcome_page.dart'; // هذا ملف واجهة الترحيب

void main() {
  runApp(const PlantsiApp());
}

class PlantsiApp extends StatelessWidget {
  const PlantsiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plantsi',
      home: const WelcomePage(),
    );
  }
}
