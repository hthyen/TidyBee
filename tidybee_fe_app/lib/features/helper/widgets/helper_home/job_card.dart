import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class JobCard extends StatelessWidget {
  final String title;
  final String district;
  final String date;
  final String time;
  final int hours;
  final double salary;
  final bool highlight;

  const JobCard({
    super.key,
    required this.title,
    required this.district,
    required this.date,
    required this.time,
    required this.hours,
    required this.salary,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: highlight ? null : Colors.white,
        gradient: highlight
            ? const LinearGradient(
                colors: [Color(0xFFFFF7E0), Color(0xFFFFE6B3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            children: [
              const Icon(Icons.cleaning_services, color: Colors.blueAccent),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Text(
                district,
                style: const TextStyle(
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(date),
              const SizedBox(width: 12),
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text("$time  •  $hours giờ"),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "${NumberFormat('#,##0').format(salary)}đ",
              style: TextStyle(
                color: highlight ? Colors.redAccent : Colors.orangeAccent,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
