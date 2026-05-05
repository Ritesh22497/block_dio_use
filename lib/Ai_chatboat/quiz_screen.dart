import 'package:block_dio_use/Ai_chatboat/local_db_service.dart';
import 'package:flutter/material.dart';


class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final AIService ai = AIService();

  String quiz = "";
  bool loading = false;

  Future<void> generate() async {
    setState(() => loading = true);

    final res = await ai.sendMessage(
        "Generate 5 MCQ questions with answers on Science");

    setState(() {
      quiz = res;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    generate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz Mode 🧪")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: loading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Text(
                  quiz,
                  style: TextStyle(fontSize: 16),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: generate,
        child: Icon(Icons.refresh),
      ),
    );
  }
}