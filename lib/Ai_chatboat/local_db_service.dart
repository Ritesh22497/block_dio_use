import 'dart:async';
import 'dart:convert';

import 'package:block_dio_use/student_ai_chatbot/models/chat_message.dart';
import 'package:block_dio_use/student_ai_chatbot/services/ai_service.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class LocalDBService {
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'chat.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE chats(
          id TEXT,
          message TEXT,
          isUser INTEGER,
          timestamp TEXT
        )
        ''');
      },
    );
  }

  Future<void> insert(ChatMessage msg) async {
    final database = await db;
    await database.insert('chats', msg.toMap());
  }

  Future<List<ChatMessage>> getMessages() async {
    final database = await db;
    final result = await database.query('chats', orderBy: 'timestamp ASC');

    return result.map((e) => ChatMessage.fromMap(e)).toList();
  }

  Future<void> clear() async {
    final database = await db;
    await database.delete('chats');
  }
}



class AIService {
  static const apiKey ="AIzaSyDqhDTwYelOD4-4uBStbcd8A28U7YvpHhs";

  Future<String> sendMessage(String msg) async {
    try {
      final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-3-flash-preview:generateContent?key=$apiKey",
      );

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": msg},
              ]
            }
          ]
        }),
      );

      final data = jsonDecode(response.body);
 print("================AI data: $data");
      if (response.statusCode == 200) {
         print("================AI response: ${data['candidates'][0]['content']['parts'][0]['text']}");
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
         print("================API Error: ${data['error']['message']}");
        return "API Error: ${data['error']['message']}";
      }
    } catch (e) {
       print("================AI Error: $e");
      return "Error: $e";
    }
  }
}

// class AIService {
//   static const String apiKey = apiKey1;

//   late final GenerativeModel model;

//   AIService() {
//     model = GenerativeModel(
//       model: 'gemini-1.5-flash-latest', // ✅ WORKING
//       apiKey: apiKey,
//     );
//   }

//   Future<String> sendMessage(String msg) async {
//     try {
//       final response = await model.generateContent([
//         Content.text(msg),
//       ]);

//       if (response.text == null || response.text!.isEmpty) {
//         return "No response from AI";
//       }

//       return response.text!;
//     } catch (e) {
//       print("🔥 AI ERROR: $e");
//       return "AI Error: $e";
//     }
//   }
// }

// class AIService {
//   static const apiKey = apiKey1;

//   final model = GenerativeModel(
//     model: 'gemini-1.5-flash-latest',
//    // model: 'gemini-1.5-flash',
//     apiKey: apiKey,
//   );

//   Future<String> sendMessage(String msg) async {
//     try {
//       final res = await model.generateContent([Content.text(msg)]);
//       return res.text ?? "No response";
//     } catch (e) {
//       print("================AI Error: $e");
//       return "AI Error: $e";
//     }
//   }
// }


class ChatProvider1 extends ChangeNotifier {
  final AIService _ai = AIService();
  final LocalDBService _db = LocalDBService();

  List<ChatMessage> messages = [];
  bool isLoading = false;

  ChatProvider() {
    loadMessages();
  }

  Future<void> loadMessages() async {
    messages = await _db.getMessages();
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().toString(),
      message: text,
      isUser: true,
      timestamp: DateTime.now(),
    );

    messages.add(userMsg);
    await _db.insert(userMsg);
    notifyListeners();

    isLoading = true;
    notifyListeners();

    final reply = await _ai.sendMessage(text);

    final botMsg = ChatMessage(
      id: DateTime.now().toString(),
      message: reply,
      isUser: false,
      timestamp: DateTime.now(),
    );

    messages.add(botMsg);
    await _db.insert(botMsg);

    isLoading = false;
    notifyListeners();
  }

  Future<void> clearChat() async {
    await _db.clear();
    messages.clear();
    notifyListeners();
  }
}


class VoiceService {
  final SpeechToText _speech = SpeechToText();

  Future<String> listen() async {
    bool available = await _speech.initialize();

    if (!available) return "";

    String resultText = "";

    _speech.listen(onResult: (result) {
      resultText = result.recognizedWords;
    });

    await Future.delayed(Duration(seconds: 5));
    _speech.stop();

    return resultText;
  }
}


class ImageService {
  final picker = ImagePicker();

  Future<XFile?> pickImage() async {
    return await picker.pickImage(source: ImageSource.gallery);
  }
}


Future<void> generatePDF(List messages) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      build: (context) {
        return pw.Column(
          children: messages.map((m) {
            return pw.Text(m.message);
          }).toList(),
        );
      },
    ),
  );

  await Printing.layoutPdf(
    onLayout: (format) async => pdf.save(),
  );
}


class PomodoroService {
  int time = 25 * 60;
  Timer? timer;

  void start(Function update) {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (time > 0) {
        time--;
        update();
      } else {
        timer?.cancel();
      }
    });
  }

  void reset() {
    time = 25 * 60;
    timer?.cancel();
  }
}

Future<String> generateQuiz(String topic) async {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey1,
  );

  final res = await model.generateContent([
    Content.text("Create 5 MCQ questions on $topic with answers")
  ]);

  return res.text ?? "";
}