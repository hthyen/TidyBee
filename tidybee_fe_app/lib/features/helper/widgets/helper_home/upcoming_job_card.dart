// features/helper/widgets/helper_home/upcoming_job_card.dart
import 'package:flutter/material.dart';

class UpcomingJobCard extends StatelessWidget {
  final String title;
  final String address;
  final String time;
  final String date;
  final double salary;
  final VoidCallback onTap;

  const UpcomingJobCard({
    super.key,
    required this.title,
    required this.address,
    required this.time,
    required this.date,
    required this.salary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(16),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text("$date • $time"),
            Text(address, style: const TextStyle(color: Colors.grey)),
          ],
        ),
        trailing: Text(
          "${(salary / 1000).toStringAsFixed(0)}k",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
    );
  }
}
