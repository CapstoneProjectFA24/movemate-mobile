import 'package:cloud_firestore/cloud_firestore.dart';

enum StaffRole { reviewer, driver, porter, manager }

class Message {
  final String id;
  final String content;
  final String senderId;
  final String senderRole;
  final List<String>? attachments;
  final DateTime timestamp;
  final DateTime? readAt;
  final String status;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.senderRole,
    this.attachments,
    required this.timestamp,
    this.readAt,
    required this.status,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Message(
      id: doc.id,
      content: data['content'],
      senderId: data['senderId'],
      senderRole: data['senderRole'],
      attachments: List<String>.from(data['attachments'] ?? []),
      timestamp: data['timestamp'] is Timestamp
          ? (data['timestamp'] as Timestamp).toDate()
          : DateTime.now(),
      readAt: data['readAt'] is Timestamp
          ? (data['readAt'] as Timestamp).toDate()
          : null,
      status: data['status'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'content': content,
      'senderId': senderId,
      'senderRole': senderRole,
      'attachments': attachments,
      'timestamp': Timestamp.fromDate(timestamp),
      'readAt': readAt != null ? Timestamp.fromDate(readAt!) : null,
      'status': status,
    };
  }
}

class Conversation {
  final String id;
  final Map<String, dynamic> participants;
  final DateTime createdAt;
  final String status;
  final Message? lastMessage;

  Conversation({
    required this.id,
    required this.participants,
    required this.createdAt,
    required this.status,
    this.lastMessage,
  });

  factory Conversation.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Conversation(
      id: doc.id,
      participants: data['participants'],
      createdAt: data['createdAt'] is Timestamp
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      status: data['status'],
      lastMessage: data['lastMessage'] != null
          ? Message.fromFirestore(data['lastMessage'])
          : null,
    );
  }
}
