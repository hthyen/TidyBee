import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tidybee_fe_app/features/helper/model/booking_request.dart';
import 'action_buttons.dart';

class JobCard extends StatelessWidget {
  final BookingRequest job;
  final String token;
  final Future<void> Function(BookingRequest) onStart;
  final Future<void> Function(BookingRequest) onComplete;
  final Future<void> Function(BookingRequest) onChat;

  const JobCard({
    super.key,
    required this.job,
    required this.token,
    required this.onStart,
    required this.onComplete,
    required this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = job.status == 5;
    final time = job.scheduledStartTime != null && job.scheduledEndTime != null
        ? "${_formatTime(job.scheduledStartTime!)} - ${_formatTime(job.scheduledEndTime!)}"
        : "Chưa xác định";
    final hours = job.estimatedDuration ?? 0;
    final createdAgo = job.createdAt != null
        ? _timeAgo(job.createdAt!)
        : "Vừa nhận";
    final price = isCompleted
        ? (job.finalPrice ?? 0)
        : (job.estimatedPrice ?? 0);

    final now = DateTime.now();
    final startTime = job.scheduledStartTime;
    final endTime = job.scheduledEndTime;
    final canChatInTime = startTime != null && endTime != null
        ? now.isAfter(startTime.subtract(const Duration(days: 1))) &&
              now.isBefore(endTime.add(const Duration(days: 1)))
        : false;
    final canOpenChat = job.status == 3 || job.status == 4;
    final canChat = canChatInTime && canOpenChat;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCompleted
            ? Border.all(color: Colors.green.shade200, width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề + trạng thái
          Row(
            children: [
              Icon(
                isCompleted ? Icons.check_circle : Icons.cleaning_services,
                color: isCompleted ? Colors.green : job.statusColor,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  job.title ?? "Dịch vụ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: isCompleted ? Colors.grey.shade600 : null,
                  ),
                ),
              ),
              Chip(
                label: Text(
                  job.statusText,
                  style: const TextStyle(color: Colors.white, fontSize: 11),
                ),
                backgroundColor: job.statusColor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Thời gian
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(_formatDate(job.scheduledStartTime)),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text("$time • $hours giờ"),
            ],
          ),
          const SizedBox(height: 8),
          // Địa chỉ
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  job.locationAddress ?? "Không rõ địa chỉ",
                  style: TextStyle(color: Colors.grey[700], fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Giá + thời gian tạo
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                createdAgo,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
              Text(
                "${NumberFormat('#,##0').format(price)}đ",
                style: const TextStyle(
                  color: Colors.orangeAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          // Nút hành động
          ActionButtons(
            job: job,
            canChat: canChat,
            canOpenChat: canOpenChat,
            onStart: () => onStart(job),
            onComplete: () => onComplete(job),
            onChat: () => onChat(job),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime d) =>
      "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
  String _formatDate(DateTime? d) =>
      d == null ? "Chưa xác định" : DateFormat('dd/MM, EEEE', 'vi').format(d);
  String _timeAgo(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 1) return "Vừa nhận";
    if (diff.inMinutes < 60) return "${diff.inMinutes} phút trước";
    if (diff.inHours < 24) return "${diff.inHours} giờ trước";
    return "${diff.inDays} ngày trước";
  }
}
