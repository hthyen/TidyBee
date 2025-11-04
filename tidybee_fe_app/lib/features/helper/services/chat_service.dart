import 'package:uuid/uuid.dart';
import 'package:tidybee_fe_app/features/helper/model/chat/chat_message.dart';

class ChatService {
  final String? token;
  final _uuid = const Uuid();

  ChatService({this.token});

  // Danh sách tin nhắn giả lập (thay bằng API sau)
  final List<ChatMessage> _mockMessages = [
    ChatMessage(
      id: const Uuid().v4(),
      text: "Xin chào! Tôi là TidyBee của bạn. Bạn cần hỗ trợ gì hôm nay?",
      isFromUser: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 3)),
    ),
  ];

  Stream<List<ChatMessage>> getMessages() {
    // Giả lập stream tin nhắn (dùng cho Riverpod/Provider sau)
    return Stream.value(_mockMessages);
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      text: text.trim(),
      isFromUser: true,
      timestamp: DateTime.now(),
    );

    _mockMessages.add(userMessage);

    // Giả lập phản hồi từ bTaskeer sau 1-2s
    await Future.delayed(
      const Duration(seconds: 1) +
          Duration(milliseconds: DateTime.now().millisecond % 1000),
    );

    final reply = ChatMessage(
      id: _uuid.v4(),
      text: _generateAutoReply(text),
      isFromUser: false,
      timestamp: DateTime.now(),
    );

    _mockMessages.add(reply);
  }

  String _generateAutoReply(String userText) {
    final replies = [
      "Cảm ơn bạn! Tôi sẽ hỗ trợ ngay.",
      "Đã nhận tin nhắn. Bạn cần tôi dọn phòng hay giặt đồ ạ?",
      "Tôi đang chuẩn bị dụng cụ. Bạn cần thêm gì không?",
      "OK, tôi sẽ đến đúng giờ nhé!",
    ];
    return (replies..shuffle()).first;
  }

  // Dùng để lấy tin nhắn mới nhất (cho UI refresh)
  List<ChatMessage> get currentMessages => List.unmodifiable(_mockMessages);
}
