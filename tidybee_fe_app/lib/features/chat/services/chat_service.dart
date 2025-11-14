import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tidybee_fe_app/features/chat/model/chat_room.dart';
import 'package:tidybee_fe_app/features/chat/model/chat_message.dart';

class ChatService {
  final String baseUrl = 'http://3.27.95.248:8080';
  final String token;
  final String currentUserId;

  ChatService(this.token, this.currentUserId);

  Map<String, String> get _headers => {
    'accept': 'text/plain',
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  /// Tạo phòng chat từ booking
  /// POST /api/Chat/rooms
  /// Body: { bookingId, customerId, helperId }
  Future<ChatRoom?> createChatRoom({
    required String bookingId,
    required String customerId,
    required String helperId,
  }) async {
    final url = Uri.parse('$baseUrl/api/Chat/rooms'); // ĐÚNG
    final body = jsonEncode({
      "bookingId": bookingId,
      "customerId": customerId,
      "helperId": helperId,
    });

    print('=== GỌI API TẠO PHÒNG ===');
    print('URL: $url'); // PHẢI LÀ https://...com/api/Chat/rooms
    print('Headers: $_headers');
    print('Body: $body');

    final response = await http.post(url, headers: _headers, body: body);

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode != 200 && response.statusCode != 201) {
      print('Tạo phòng thất bại: ${response.statusCode}');
      return null;
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json['success'] == true && json['data'] != null) {
      return ChatRoom.fromJson(json['data']);
    }
    return null;
  }

  Future<ChatMessage?> sendMessage({
    required String roomId,
    required String content,
    int messageType = 1, // 1 = text
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? contentType,
  }) async {
    final body = <String, dynamic>{
      "chatRoomId": roomId,
      "content": content,
      "messageType": messageType,
    };

    // Chỉ thêm các trường nếu có giá trị
    if (fileUrl != null && fileUrl.isNotEmpty) body["fileUrl"] = fileUrl;
    if (fileName != null && fileName.isNotEmpty) body["fileName"] = fileName;
    if (fileSize != null && fileSize > 0) body["fileSize"] = fileSize;
    if (contentType != null && contentType.isNotEmpty)
      body["contentType"] = contentType;

    final response = await http.post(
      Uri.parse('$baseUrl/api/Chat/rooms/$roomId/messages'),
      headers: _headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      print('Gửi tin nhắn thất bại: ${response.statusCode}');
      print(response.body);
      return null;
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    if (json['success'] == true && json['data'] != null) {
      return ChatMessage.fromJson(json['data']);
    } else {
      print('Gửi tin nhắn thất bại: ${json['message']}');
      return null;
    }
  }

  Future<List<ChatRoom>> getRooms({int page = 1, int pageSize = 20}) async {
    final uri = Uri.parse('$baseUrl/api/Chat/rooms').replace(
      queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      print('Lỗi getRooms: ${response.statusCode}');
      print(response.body);
      return [];
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (json['success'] == true && json['data'] != null) {
      final List data = json['data'];
      return data.map((e) => ChatRoom.fromJson(e)).toList();
    } else {
      print('getRooms thất bại: ${json['message']}');
      return [];
    }
  }

  Future<List<ChatMessage>> getMessages({
    required String roomId,
    int page = 1,
    int pageSize = 50,
    bool includeSystemMessages = true,
  }) async {
    final uri = Uri.parse('$baseUrl/api/Chat/rooms/$roomId/messages').replace(
      queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
        'includeSystemMessages': includeSystemMessages.toString(),
      },
    );

    final response = await http.get(uri, headers: _headers);

    if (response.statusCode != 200) {
      print('Lỗi getMessages: ${response.statusCode}');
      print(response.body);
      return [];
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));

    if (json['success'] == true && json['data'] != null) {
      final List messages = json['data']['messages'] ?? [];
      return messages.map((e) => ChatMessage.fromJson(e)).toList();
    } else {
      print('getMessages thất bại: ${json['message']}');
      return [];
    }
  }

  Future<bool> markAsRead(String messageId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/Chat/messages/$messageId/read'),
      headers: _headers,
    );

    if (response.statusCode != 200) {
      print('markAsRead thất bại: ${response.statusCode}');
      print(response.body);
      return false;
    }

    final json = jsonDecode(utf8.decode(response.bodyBytes));
    return json['success'] == true;
  }
}
