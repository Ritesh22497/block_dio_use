// class ChatMessage {
//   final String id;
//   final String message;
//   final bool isUser;
//   final DateTime timestamp;
//   final String? subject;

//   ChatMessage({
//     required this.id,
//     required this.message,
//     required this.isUser,
//     required this.timestamp,
//     this.subject,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'message': message,
//       'isUser': isUser,
//       'timestamp': timestamp.toIso8601String(),
//       'subject': subject,
//     };
//   }

//   factory ChatMessage.fromMap(Map<String, dynamic> map) {
//     return ChatMessage(
//       id: map['id'] ?? '',
//       message: map['message'] ?? '',
//       isUser: map['isUser'] ?? false,
//       timestamp: DateTime.parse(map['timestamp']),
//       subject: map['subject'],
//     );
//   }
// }
class ChatMessage {
  final String id;
  final String message;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.id,
    required this.message,
    required this.isUser,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'message': message,
       'isUser': isUser ? 1 : 0, 
     // 'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    return ChatMessage(
      id: map['id'],
      message: map['message'],
       isUser: map['isUser'] == 1, // ✅ FIX
     // isUser: map['isUser'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }
}