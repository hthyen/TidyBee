enum MessageType { text, image, file, system }

class ChatMessage {
  final String id;
  final String chatRoomId;
  final String senderId;
  final String senderName;
  final MessageType messageType;
  final String content;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? contentType;
  final bool isRead;
  final DateTime? sentAt;

  ChatMessage({
    required this.id,
    required this.chatRoomId,
    required this.senderId,
    required this.senderName,
    required this.messageType,
    required this.content,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.contentType,
    required this.isRead,
    this.sentAt,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      chatRoomId: json['chatRoomId']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      senderName: json['senderName'] ?? 'Unknown',
      messageType: _parseMessageType(json['messageType']),
      content: json['content'] ?? '',
      fileUrl: json['fileUrl'],
      fileName: json['fileName'],
      fileSize: json['fileSize'],
      contentType: json['contentType'],
      isRead: json['isRead'] ?? false,
      sentAt: json['sentAt'] != null ? DateTime.parse(json['sentAt']) : null,
    );
  }

  static MessageType _parseMessageType(int? type) {
    switch (type) {
      case 1:
        return MessageType.text;
      case 2:
        return MessageType.image;
      case 3:
        return MessageType.file;
      case 4:
        return MessageType.system;
      default:
        return MessageType.text;
    }
  }
}
