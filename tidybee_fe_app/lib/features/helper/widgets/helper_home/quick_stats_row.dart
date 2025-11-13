import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';

class QuickStatsRow extends StatelessWidget {
  final int completedJobs;
  final double rating;
  final int reviewCount; // THÊM
  final int pendingJobs;

  const QuickStatsRow({
    super.key,
    required this.completedJobs,
    required this.rating,
    required this.reviewCount, // THÊM
    required this.pendingJobs,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildStat("Hoàn thành", completedJobs.toString(), Icons.check_circle),
        const SizedBox(width: 12),
        _buildStat(
          "Đánh giá",
          "${rating.toStringAsFixed(1)} ($reviewCount)",
          Icons.star,
        ),
        const SizedBox(width: 12),
        _buildStat("Đang chờ", pendingJobs.toString(), Icons.schedule),
      ],
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
