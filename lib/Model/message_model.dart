class MessageModel {
  final String type; // e.g., 'text', 'image'
  final String message; // Message content
  final DateTime time; // Message timestamp
  final String path; // Optional file path for media
  final String senderId; // ID of the sender
  final String targetId; // ID of the receiver
  final String? status; // e.g., 'sent', 'delivered', 'read'

  MessageModel({
    required this.type,
    required this.message,
    required this.time,
    this.path = "",
    required this.senderId,
    required this.targetId,
    this.status = 'sent', // Default status
  });

}
