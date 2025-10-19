import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';

class HelperBookingScreen extends StatefulWidget {
  final String? token;

  const HelperBookingScreen({super.key, this.token});

  @override
  State<HelperBookingScreen> createState() => _HelperBookingScreenState();
}

class _HelperBookingScreenState extends State<HelperBookingScreen> {
  int _selectedTabIndex = 0; // 0: Việc mới, 1: Đã nhận
  int _selectedDateIndex = 0;

  final List<DateTime> _dates = List.generate(
    7,
    (index) => DateTime.now().add(Duration(days: index)),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff6f6f6),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Quản lý lịch làm việc"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 🔹 Tabs: Việc mới / Đã nhận
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                _buildTabButton("Việc mới", 0),
                _buildTabButton("Đã nhận", 1),
              ],
            ),
          ),

          // 🔹 Thanh chọn ngày
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _dates.length,
              itemBuilder: (context, index) {
                final date = _dates[index];
                final isSelected = index == _selectedDateIndex;
                final day = DateFormat('E', 'vi').format(date).toUpperCase();
                final dayNum = date.day;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedDateIndex = index);
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          day,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          dayNum.toString(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 Danh sách ca sáng / chiều
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildShiftSection(
                    title: "Buổi sáng",
                    jobs: [
                      _Job(
                        title: "Dọn dẹp nhà",
                        district: "Quận 1",
                        date: "12/06/2023",
                        time: "11:00 - 15:00",
                        hours: 4,
                        salary: 350000,
                      ),
                    ],
                  ),
                  _buildShiftSection(
                    title: "Buổi chiều",
                    jobs: [
                      _Job(
                        title: "Dọn dẹp nhà",
                        district: "Quận 1",
                        date: "12/06/2023",
                        time: "17:00 - 21:00",
                        hours: 4,
                        salary: 350000,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String text, int index) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? AppColors.primary : Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShiftSection({required String title, required List<_Job> jobs}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        for (var job in jobs) _buildJobCard(job),
      ],
    );
  }

  Widget _buildJobCard(_Job job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
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
              Expanded(
                child: Text(
                  job.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                job.district,
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
              Text(job.date),
              const SizedBox(width: 12),
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text("${job.time}  •  ${job.hours} giờ"),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "${NumberFormat('#,##0').format(job.salary)}đ",
              style: const TextStyle(
                color: Colors.orangeAccent,
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

class _Job {
  final String title;
  final String district;
  final String date;
  final String time;
  final int hours;
  final int salary;

  _Job({
    required this.title,
    required this.district,
    required this.date,
    required this.time,
    required this.hours,
    required this.salary,
  });
}
