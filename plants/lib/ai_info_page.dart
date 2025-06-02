import 'package:flutter/material.dart';

class AIInfoPage extends StatelessWidget {
  final String info;

  const AIInfoPage({super.key, required this.info});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Plant Information"),
        backgroundColor: const Color(0xFF8DBF67),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            info,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
