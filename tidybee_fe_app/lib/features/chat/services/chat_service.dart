import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tidybee_fe_app/features/chat/model/chat_message.dart';
import 'package:tidybee_fe_app/features/chat/model/chat_room.dart';

class ChatService {
  final String baseUrl =
      'https://arc-mortgages-profits-incentive.trycloudflare.com';
  final String token;
  final String currentUserId;

  ChatService(this.token, this.currentUserId);

  Map<String, String> get _headers => {
    'accept': 'text/plain',
    'Authorization': 'Bearer $token',
    'Content-Type': 'application/json',
  };

  // fetch list of chat rooms
  Future<List<ChatRoom>> getRooms({int page = 1, int pageSize = 20}) async {
    final uri = Uri.parse('$baseUrl/api/Chat/rooms').replace(
      queryParameters: {
        'page': page.toString(),
        'pageSize': pageSize.toString(),
      },
    );

    final response = await http.get(uri, headers: _headers);
    final json = jsonDecode(response.body);

    if (json['success'] == true) {
      final List data = json['data'];
      return data.map((e) => ChatRoom.fromJson(e)).toList();
    } else {
      throw Exception(json['message'] ?? 'Lỗi tải danh sách phòng');
    }
  }

  // fetch messages for a room
  Future<List<ChatMessage>> getMessages(
    String roomId, {
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
    final json = jsonDecode(response.body);

    if (json['success'] == true) {
      final List messages = json['data']['messages'];
      return messages.map((e) => ChatMessage.fromJson(e)).toList();
    } else {
      throw Exception(json['message'] ?? 'Lỗi tải tin nhắn');
    }
  }

  // send a new message
  Future<ChatMessage> sendMessage(String roomId, String content) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/Chat/rooms/$roomId/messages'),
      headers: _headers,
      body: jsonEncode({
        "chatRoomId": roomId,
        "content": content,
        "messageType": 1, // text
      }),
    );

    final json = jsonDecode(response.body);
    if (json['success'] == true) {
      return ChatMessage.fromJson(json['data']);
    } else {
      throw Exception(json['message'] ?? 'Gửi thất bại');
    }
  }

  // get unread count for a room
  Future<int> getUnreadCount(String roomId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Chat/rooms/$roomId/unread-count'),
      headers: _headers,
    );

    final json = jsonDecode(response.body);
    return json['success'] == true ? json['data'] as int : 0;
  }

  // get room by booking id
  Future<ChatRoom?> getRoomByBookingId(String bookingId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/Chat/rooms/booking/$bookingId'),
      headers: _headers,
    );

    final json = jsonDecode(response.body);
    if (json['success'] == true && json['data'] != null) {
      return ChatRoom.fromJson(json['data']);
    }
    return null;
  }

  // mark message as read
  Future<bool> markAsRead(String messageId) async {
    final response = await http.put(
      Uri.parse('$baseUrl/api/Chat/messages/$messageId/read'),
      headers: _headers,
    );

    final json = jsonDecode(response.body);
    return json['success'] == true;
  }
}
