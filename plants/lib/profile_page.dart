import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String userName;
  const ProfilePage({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/bg.jpg',
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.green.withOpacity(0.3),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Hello $userName!',
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Welcome to the online store',
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 30),
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile.png'), // صورة افتراضية
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // اختيار صورة جديدة (بنعملها لاحقاً)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Change profile picture'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // رفع الصورة (لاحقاً)
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Upload picture'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // تخطي الصفحة
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
