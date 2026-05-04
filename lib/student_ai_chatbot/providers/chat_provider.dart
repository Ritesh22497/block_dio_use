import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/ai_service.dart';
import '../services/firebase_service.dart';

class ChatProvider extends ChangeNotifier {
  final AIService _aiService = AIService();
  final FirebaseService _firebaseService = FirebaseService();

  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  String _selectedSubject = 'General';

  List<ChatMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String get selectedSubject => _selectedSubject;

  final List<String> subjects = [
    'General',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer Science',
    'English',
    'History',
    'Geography',
  ];

  ChatProvider() {
    _initializeChat();
  }

  void _initializeChat() async {
    await _firebaseService.signInAnonymously();
    _loadChatHistory();
  }

  void _loadChatHistory() {
    _firebaseService.getChatHistory().listen((history) {
      _messages = history;
      notifyListeners();
    });
  }

  void setSubject(String subject) {
    _selectedSubject = subject;
    notifyListeners();
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: text,
      isUser: true,
      timestamp: DateTime.now(),
      subject: _selectedSubject,
    );

    _messages.add(userMessage);
    await _firebaseService.saveMessage(userMessage);
    notifyListeners();

    // Get AI response
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _aiService.sendMessage(text, _selectedSubject);

      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: response,
        isUser: false,
        timestamp: DateTime.now(),
        subject: _selectedSubject,
      );

      _messages.add(aiMessage);
      await _firebaseService.saveMessage(aiMessage);
    } catch (e) {
      final errorMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        message: "Sorry, I encountered an error: ${e.toString()}",
        isUser: false,
        timestamp: DateTime.now(),
      );
      _messages.add(errorMessage);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> clearChat() async {
    _messages.clear();
    await _firebaseService.clearHistory();
    notifyListeners();
  }
}