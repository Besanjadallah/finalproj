import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ChatMessage {
  final dynamic content; // String (path) أو Uint8List (Web)
  final bool isImage;
  final bool isSender;

  ChatMessage({required this.content, this.isImage = false, this.isSender = true});
}

class PlantChatPage extends StatefulWidget {
  const PlantChatPage({super.key});

  @override
  State<PlantChatPage> createState() => _PlantChatPageState();
}

class _PlantChatPageState extends State<PlantChatPage> {
  final List<ChatMessage> messages = [];
  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      if (kIsWeb) {
        final bytes = await pickedFile.readAsBytes();
        addUserImageMessageWeb(bytes);
        await analyzeImageWeb(bytes);
      } else {
        final file = File(pickedFile.path);
        addUserImageMessage(file);
        await analyzeImage(file);
      }
    }
  }

  void addUserImageMessage(File image) {
    messages.add(ChatMessage(content: image.path, isImage: true, isSender: true));
    setState(() {});
  }

  void addUserImageMessageWeb(Uint8List bytes) {
    messages.add(ChatMessage(content: bytes, isImage: true, isSender: true));
    setState(() {});
  }

  Future<void> analyzeImage(File image) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.1.18/api/plant/analyze-plant'),
    );
    request.files.add(await http.MultipartFile.fromPath('image', image.path));
    final response = await request.send();
    await _handleResponse(response);
  }

  Future<void> analyzeImageWeb(Uint8List bytes) async {
  final request = http.MultipartRequest(
    'POST',
    Uri.parse('http://192.168.1.18:8080/api/plant/analyze-plant'), // غيّري localhost لـ IP الحقيقي
  );
  request.files.add(http.MultipartFile.fromBytes('image', bytes, filename: 'web_image.jpg'));
  final response = await request.send();

  print("🔵 Status code: ${response.statusCode}");

  final res = await response.stream.bytesToString();
  print("🟢 Response body: $res");

  if (response.statusCode == 200) {
    final data = json.decode(res);

    String plantName = data['suggestions']?[0]?['plant_name'] ?? "غير معروف";
    String? probability = data['suggestions']?[0]?['probability']?.toStringAsFixed(2);
    String? health = data['health_assessment']?['is_healthy'] == true ? "صحية ✅" : "تحتاج فحص ❌";

    final reply = "🌿 نبتتك: $plantName\n🎯 دقة: $probability\n🩺 الحالة: $health";
    messages.add(ChatMessage(content: reply, isSender: false));
  } else {
    messages.add(ChatMessage(content: "❌ فشل التحليل", isSender: false));
  }

  setState(() {});
}


  Future<void> _handleResponse(http.StreamedResponse response) async {
    if (response.statusCode == 200) {
      final res = await response.stream.bytesToString();
      final data = json.decode(res);

      String plantName = data['suggestions']?[0]?['plant_name'] ?? "غير معروف";
      String? probability = data['suggestions']?[0]?['probability']?.toStringAsFixed(2);
      String? health = data['health_assessment']?['is_healthy'] == true ? "صحية ✅" : "تحتاج فحص ❌";

      final reply = "🌿 نبتتك: $plantName\n🎯 دقة: $probability\n🩺 الحالة: $health";
      messages.add(ChatMessage(content: reply, isSender: false));
    } else {
      messages.add(ChatMessage(content: "❌ فشل التحليل", isSender: false));
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تحليل نبتة عبر الذكاء الصناعي 🌿'),
        backgroundColor: const Color(0xFF8DBF67),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg.isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: msg.isSender ? Colors.green[200] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: msg.isImage
                        ? kIsWeb
                            ? Image.memory(msg.content as Uint8List, width: 180)
                            : Image.file(File(msg.content as String), width: 180)
                        : Text(msg.content.toString()),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: pickImage,
                  tooltip: 'ارفع صورة نبتة',
                ),
                const Expanded(
                  child: Text("اختر صورة لتحليل النبتة", style: TextStyle(color: Colors.grey)),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}