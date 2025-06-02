import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AskQuestionPage extends StatefulWidget {
  const AskQuestionPage({super.key});

  @override
  State<AskQuestionPage> createState() => _AskQuestionPageState();
}

class _AskQuestionPageState extends State<AskQuestionPage> {
  final TextEditingController _questionController = TextEditingController();

  Future<void> submitQuestion() async {
    final questionText = _questionController.text.trim();

    if (questionText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a question")),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    final response = await http.post(
      Uri.parse('http://192.168.3.142:5000/api/questions/add'),

      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'text': questionText,
        'user': 'Anonymous',
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Question submitted successfully!")),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit question")),
      );
    }
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ask a Question"),
        backgroundColor: const Color(0xFF8DBF67),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _questionController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Write your question here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitQuestion,
              child: const Text("Submit"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8DBF67),
                foregroundColor: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
