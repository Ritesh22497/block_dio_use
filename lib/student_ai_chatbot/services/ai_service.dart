// import 'package:google_generative_ai/google_generative_ai.dart';

// class AIService {
//   // Get your FREE API key from: https://makersuite.google.com/app/apikey
//   //static const String _apiKey = 'YOUR_GEMINI_API_KEY_HERE';
//   static const String _apiKey = 'AIzaSyBlpQcnePsNFRDtLwP1iP3-j1-DeJDjgPI';
  
//   late final GenerativeModel _model;
  
//   AIService() {
//     _model = GenerativeModel(
//       model: 'gemini-pro',
//       apiKey: _apiKey,
//       generationConfig: GenerationConfig(
//         temperature: 0.7,
//         topK: 40,
//         topP: 0.95,
//         maxOutputTokens: 1024,
//       ),
//     );
//   }

//   // Send message to AI and get response
//   Future<String> sendMessage(String message, String subject) async {
//     try {
//       // Create context-aware prompt for students
//       final prompt = _createStudentPrompt(message, subject);
      
//       final content = [Content.text(prompt)];
//       final response = await _model.generateContent(content);
      
//       if (response.text != null && response.text!.isNotEmpty) {
//         return response.text!;
//       } else {
//         return "Sorry, I couldn't generate a response. Please try again.";
//       }
//     } catch (e) {
//       print('AI Error: $e');
//       return "Error: ${e.toString()}";
//     }
//   }

//   // Create student-focused prompt
//   String _createStudentPrompt(String question, String subject) {
//     return '''
// You are an expert AI tutor helping students. Your role is to:
// 1. Provide clear, simple explanations
// 2. Break down complex topics into easy steps
// 3. Give examples when needed
// 4. Encourage learning with positive reinforcement
// 5. If it's a math problem, show step-by-step solution
// 6. If it's code, provide working examples

// Subject: $subject
// Student Question: $question

// Please provide a helpful, educational response:
// ''';
//   }

//   // Get conversation with chat history
//   Future<String> sendMessageWithHistory(
//     String message,
//     List<Map<String, String>> chatHistory,
//   ) async {
//     try {
//       final chat = _model.startChat(history: [
//         for (var msg in chatHistory)
//           Content.text(msg['role'] == 'user' 
//             ? 'Student: ${msg['message']}'
//             : 'Tutor: ${msg['message']}')
//       ]);

//       final response = await chat.sendMessage(Content.text(message));
//       return response.text ?? "No response generated.";
//     } catch (e) {
//       print('Chat Error: $e');
//       return "Error in conversation: ${e.toString()}";
//     }
//   }
// }
import 'package:google_generative_ai/google_generative_ai.dart';
  const String apiKey1 = "AIzaSyDT5gmMtxav7sHc8XKok37ojx09JnCTquU";
class AIService {
 
  static const String apiKey = apiKey1; // 🔥 CHANGE THIS

  late final GenerativeModel model;

  AIService() {
    model = GenerativeModel(
      model: 'gemini-1.5-flash', // ✅ UPDATED
      apiKey: apiKey,
    );
  }
Future<String> sendMessage(String message) async {
  try {
    print("Sending to AI: $message");

    final response = await model.generateContent([
      Content.text("Explain simply: $message")
    ]);

    print("AI RAW RESPONSE: ${response.text}");

    return response.text ?? "No response from AI";
  } catch (e) {
    print("AI ERROR: $e");
    return "AI Error: $e";
  }
}
  // Future<String> sendMessage(String message) async {
  //   try {
  //     final response = await model.generateContent([
  //       Content.text("Explain simply: $message")
  //     ]);

  //     return response.text ?? "No response";
  //   } catch (e) {
  //     return "AI Error: $e";
  //   }
  // }


}