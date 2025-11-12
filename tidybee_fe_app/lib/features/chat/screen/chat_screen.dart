import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/features/chat/model/chat_message.dart';
import 'package:tidybee_fe_app/features/chat/services/chat_service.dart';
import 'package:tidybee_fe_app/features/chat/widget/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String token;
  final String roomId;
  final String opponentName;
  final String currentUserId;

  const ChatScreen({
    super.key,
    required this.token,
    required this.roomId,
    required this.opponentName,
    required this.currentUserId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late ChatService _chatService;
  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _chatService = ChatService(widget.token, widget.currentUserId);
    _loadMessages();
    _markAllAsRead();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await _chatService.getMessages(
        roomId: widget.roomId,
        page: 1,
        pageSize: 50,
        includeSystemMessages: true,
      );

      setState(() {
        _messages = messages
          ..sort((a, b) {
            final dateA = a.sentAt;
            final dateB = b.sentAt;

            // Xử lý null: tin nhắn không có thời gian → đẩy xuống dưới
            if (dateA == null && dateB == null) return 0;
            if (dateA == null) return 1;
            if (dateB == null) return -1;

            return dateA.compareTo(dateB); // AN TOÀN
          });
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() => _isLoading = false);
      _showError('Lỗi tải tin nhắn: $e');
    }
  }

  Future<void> _markAllAsRead() async {
    for (var msg in _messages) {
      if (!msg.isRead && msg.senderId != widget.currentUserId) {
        await _chatService.markAsRead(msg.id);
      }
    }
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending) return;

    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final optimisticMessage = ChatMessage(
      id: tempId,
      chatRoomId: widget.roomId,
      senderId: widget.currentUserId,
      senderName: 'Bạn',
      messageType: MessageType.text,
      content: text,
      isRead: true,
      sentAt: DateTime.now(),
    );

    setState(() {
      _messages.add(optimisticMessage);
      _isSending = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final sentMessage = await _chatService.sendMessage(
        roomId: widget.roomId,
        content: text,
      );

      // KIỂM TRA NULL TRƯỚC KHI DÙNG
      if (sentMessage == null) {
        throw Exception("Tin nhắn trả về null");
      }

      setState(() {
        _messages.removeWhere((m) => m.id == tempId);
        _messages.add(sentMessage); // BÂY GIỜ AN TOÀN
        _isSending = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() => _isSending = false);
      _showError('Gửi tin nhắn thất bại: $e');
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showError(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.white,
              child: Text(
                widget.opponentName.isNotEmpty
                    ? widget.opponentName[0].toUpperCase()
                    : 'K',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.opponentName,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Text(
                    "Đang hoạt động",
                    style: TextStyle(fontSize: 12, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                ? const Center(child: Text('Chưa có tin nhắn'))
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final showDate =
                          index == 0 || _shouldShowDate(_messages, index);
                      return Column(
                        children: [
                          if (showDate) _buildDateHeader(message.sentAt),
                          ChatBubble(
                            message: message,
                            currentUserId: widget.currentUserId,
                            opponentName: widget.opponentName,
                          ),
                        ],
                      );
                    },
                  ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  bool _shouldShowDate(List<ChatMessage> messages, int index) {
    if (index == 0) return true;
    final current = messages[index].sentAt;
    final previous = messages[index - 1].sentAt;
    if (current == null || previous == null) return false;
    return !DateTime(
      current.year,
      current.month,
      current.day,
    ).isAtSameMomentAs(DateTime(previous.year, previous.month, previous.day));
  }

  Widget _buildDateHeader(DateTime? date) {
    if (date == null) return const SizedBox.shrink();
    final formatter = DateFormat('dd MMMM yyyy', 'vi');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            formatter.format(date),
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              enabled: !_isSending,
              decoration: InputDecoration(
                hintText: 'Nhập tin nhắn...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton(
            onPressed: _isSending ? null : _sendMessage,
            mini: true,
            backgroundColor: _isSending ? Colors.grey : AppColors.primary,
            elevation: 2,
            child: _isSending
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.send, color: Colors.white, size: 20),
          ),
        ],
      ),
    );
  }
}
