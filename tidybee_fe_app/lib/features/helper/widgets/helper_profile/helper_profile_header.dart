import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/features/helper/model/helper.dart';

class HelperProfileHeader extends StatelessWidget {
  final Helper helper;
  final VoidCallback onEdit;

  const HelperProfileHeader({
    super.key,
    required this.helper,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final avatarUrl = helper.helperAvatar;
    final name = helper.helperName ?? '—';
    final isAvailable = helper.isAvailable ?? false;
    final rating = helper.rating;
    final reviewCount = helper.reviewCount ?? 0;

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: avatarUrl != null
              ? NetworkImage(avatarUrl)
              : const NetworkImage('https://i.pravatar.cc/150?img=3'),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.circle,
              color: isAvailable ? Colors.green : Colors.red,
              size: 10,
            ),
            const SizedBox(width: 6),
            Text(
              isAvailable ? 'Đang sẵn sàng' : 'Không khả dụng',
              style: TextStyle(color: isAvailable ? Colors.green : Colors.red),
            ),
          ],
        ),
        const SizedBox(height: 6),
        if (rating != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 18),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              if (reviewCount > 0) ...[
                const SizedBox(width: 4),
                Text('($reviewCount lượt)'),
              ],
            ],
          )
        else
          const Text('Chưa có đánh giá', style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 12),
      ],
    );
  }
}
