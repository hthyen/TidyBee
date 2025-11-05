import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import '../model/chat_room.dart';

class ChatRoomItem extends StatelessWidget {
  final ChatRoom room;
  final String currentUserId;
  final VoidCallback onTap;

  const ChatRoomItem({
    super.key,
    required this.room,
    required this.currentUserId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // automatically determine the other person's name
    final String opponentName = room.customerId == currentUserId
        ? room.helperName
        : room.customerName;

    //// check if the last message is from the current user
    final bool lastMsgIsMe = room.lastMessage?.senderId == currentUserId;

    // content of the last message
    final String lastMsgContent =
        room.lastMessage?.content ?? 'Chưa có tin nhắn';

    // most recent activity time
    final String time = room.lastActivity != null
        ? DateFormat('HH:mm').format(room.lastActivity!)
        : '';

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 24,
        backgroundColor: AppColors.primary.withOpacity(0.15),
        child: Text(
          opponentName.isNotEmpty ? opponentName[0].toUpperCase() : 'K',
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      title: Text(
        opponentName,
        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // service name (if available)
          if (room.serviceTypeName.isNotEmpty)
            Text(
              room.serviceTypeName,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 2),
          // last message preview
          Text(
            lastMsgIsMe ? 'Bạn: $lastMsgContent' : lastMsgContent,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
              fontWeight: lastMsgIsMe ? FontWeight.w500 : FontWeight.normal,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // time display
          if (time.isNotEmpty)
            Text(
              time,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          const SizedBox(height: 4),
          // Badge unread
          if (room.unreadCount > 0)
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
              child: Text(
                room.unreadCount > 99 ? '99+' : '${room.unreadCount}',
                style: const TextStyle(color: Colors.white, fontSize: 10),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }
}
