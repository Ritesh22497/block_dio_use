import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/chat_message.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  String? get userId => _auth.currentUser?.uid;

  // Sign in anonymously (for demo)
  Future<void> signInAnonymously() async {
    try {
      await _auth.signInAnonymously();
    } catch (e) {
      print('Auth Error: $e');
    }
  }

  // Save message to Firestore
  Future<void> saveMessage(ChatMessage message) async {
    if (userId == null) await signInAnonymously();
    
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .add(message.toMap());
    } catch (e) {
      print('Save Error: $e');
    }
  }

  // Get chat history
  Stream<List<ChatMessage>> getChatHistory() {
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('chats')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ChatMessage.fromMap(doc.data()))
            .toList());
  }

  // Clear chat history
  Future<void> clearHistory() async {
    if (userId == null) return;

    try {
      final batch = _firestore.batch();
      final snapshots = await _firestore
          .collection('users')
          .doc(userId)
          .collection('chats')
          .get();

      for (var doc in snapshots.docs) {
        batch.delete(doc.reference);
      }

      await batch.commit();
    } catch (e) {
      print('Clear Error: $e');
    }
  }
}