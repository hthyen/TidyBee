import 'chat_message.dart';

class ChatRoom {
  final String id;
  final String bookingId;
  final String customerId;
  final String helperId;
  final String customerName;
  final String helperName;
  final String serviceTypeName;
  final int unreadCount;
  final DateTime? lastActivity;
  final ChatMessage? lastMessage;

  ChatRoom({
    required this.id,
    required this.bookingId,
    required this.customerId,
    required this.helperId,
    required this.customerName,
    required this.helperName,
    required this.serviceTypeName,
    required this.unreadCount,
    this.lastActivity,
    this.lastMessage,
  });

  factory ChatRoom.fromJson(Map<String, dynamic> json) {
    return ChatRoom(
      id: json['id']?.toString() ?? '',
      bookingId: json['bookingId']?.toString() ?? '',
      customerId: json['customerId']?.toString() ?? '',
      helperId: json['helperId']?.toString() ?? '',
      customerName: json['customerName'] ?? 'Khách hàng',
      helperName: json['helperName'] ?? 'Helper',
      serviceTypeName: json['serviceTypeName'] ?? '',
      unreadCount: json['unreadCount'] ?? 0,
      lastActivity: json['lastActivity'] != null
          ? DateTime.parse(json['lastActivity'])
          : null,
      lastMessage: json['lastMessage'] != null
          ? ChatMessage.fromJson(json['lastMessage'])
          : null,
    );
  }
}
