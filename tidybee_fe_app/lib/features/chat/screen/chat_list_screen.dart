import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/core/common_widgets/notification_service.dart';
import 'package:tidybee_fe_app/features/chat/model/chat_room.dart';
import 'package:tidybee_fe_app/features/chat/services/chat_service.dart';
import 'package:tidybee_fe_app/features/chat/widget/chat_room_item.dart';

class ChatListScreen extends StatefulWidget {
  final String token;
  final String currentUserId; // → Đây là CUSTOMER ID

  const ChatListScreen({
    super.key,
    required this.token,
    required this.currentUserId,
  });

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  late ChatService _chatService;
  List<ChatRoom> _rooms = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _chatService = ChatService(widget.token, widget.currentUserId);
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final rooms = await _chatService.getRooms(page: 1, pageSize: 50);

      if (!mounted) return;

      setState(() {
        _rooms = rooms;
        _isLoading = false;
      });
    } on FormatException {
      NotificationService.showError(context, "Dữ liệu không hợp lệ");
    } catch (e) {
      NotificationService.showError(context, "Lỗi: ${e.toString()}");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin nhắn'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _rooms.isEmpty
          ? const Center(
              child: Text(
                'Chưa có cuộc trò chuyện nào',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadRooms,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: _rooms.length,
                itemBuilder: (context, index) {
                  final room = _rooms[index];

                  // === TỰ ĐỘNG LẤY TÊN HELPER ===
                  final opponentName = room.helperName.isNotEmpty == true
                      ? room.helperName
                      : "Helper";

                  return ChatRoomItem(
                    room: room,
                    currentUserId: widget.currentUserId,
                    onTap: () {
                      print(
                        'ChatListScreen - currentUserId: ${widget.currentUserId}',
                      );

                      context.push(
                        '/chat-detail',
                        extra: {
                          'roomId': room.id,
                          'opponentName': opponentName,
                          'token': widget.token,
                          'currentUserId': widget.currentUserId,
                        },
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
