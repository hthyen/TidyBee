// features/helper/widgets/helper_home/quick_stats_row.dart
import 'package:flutter/material.dart';

class QuickStatsRow extends StatelessWidget {
  final int completedJobs;
  final double rating;
  final int pendingJobs;

  const QuickStatsRow({
    super.key,
    required this.completedJobs,
    required this.rating,
    required this.pendingJobs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statItem(Icons.check_circle, "$completedJobs", "Hoàn thành"),
        const SizedBox(width: 12),
        _statItem(Icons.star, rating.toStringAsFixed(1), "Đánh giá"),
        const SizedBox(width: 12),
        _statItem(Icons.schedule, "$pendingJobs", "Đang chờ"),
      ],
    );
  }

  Widget _statItem(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.orange, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
