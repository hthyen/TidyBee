import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/features/helper/model/booking_request.dart';

class ActionButtons extends StatelessWidget {
  final BookingRequest job;
  final bool canChat;
  final bool canOpenChat;
  final VoidCallback onStart;
  final VoidCallback onComplete;
  final VoidCallback onChat;

  const ActionButtons({
    super.key,
    required this.job,
    required this.canChat,
    required this.canOpenChat,
    required this.onStart,
    required this.onComplete,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    if (job.status == 5 || !(job.status == 3 || job.status == 4))
      return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (job.status == 3)
            ElevatedButton(
              onPressed: onStart,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text("Bắt đầu", style: TextStyle(fontSize: 14)),
            ),
          if (job.status == 4)
            ElevatedButton(
              onPressed: onComplete,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              child: const Text("Hoàn thành", style: TextStyle(fontSize: 14)),
            ),
          const SizedBox(width: 8),
          if (canOpenChat)
            ElevatedButton.icon(
              onPressed: canChat ? onChat : null,
              icon: const Icon(Icons.chat_bubble_outline, size: 16),
              label: Text(
                canChat ? "Chat" : "Xem chat",
                style: const TextStyle(fontSize: 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: canChat ? Colors.white : Colors.grey,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
