import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tidybee_fe_app/core/common_services/format_money.dart';

class WorkingTimeSection extends StatefulWidget {
  final String price;
  final Function(double price, DateTime selectedDate)? onPriceChanged;
  final Function(TimeOfDay start)? onStartTimeChanged;
  final Function(TimeOfDay end)? onEndTimeChanged;
  final Function(bool isRecurring, DateTime? recurringEndDate)?
  onRecurringChanged;

  const WorkingTimeSection({
    super.key,
    required this.price,
    this.onPriceChanged,
    this.onStartTimeChanged,
    this.onEndTimeChanged,
    this.onRecurringChanged,
  });

  @override
  State<WorkingTimeSection> createState() => _WorkingTimeSectionState();
}

class _WorkingTimeSectionState extends State<WorkingTimeSection> {
  late List<DateTime> next7Days;
  int selectedIndex = 0;
  double selectedPrice = 0;
  TimeOfDay? selectedStartTime;
  TimeOfDay? selectedEndTime;
  bool isRecurring = false;
  DateTime? recurringEndDate;

  // Method generate next 7 days from today
  void _generateNext7Days() {
    final now = DateTime.now();

    next7Days = List.generate(7, (i) => now.add(Duration(days: i)));
  }

  // Format for days
  String _getWeekdayShort(DateTime date) {
    const weekdays = ["CN", "T2", "T3", "T4", "T5", "T6", "T7"];
    return weekdays[date.weekday % 7]; // weekday=7 => CN
  }

  // Get price and format price
  String _getPrice(DateTime date, String basePriceStr) {
    double valueInt = double.parse(basePriceStr);

    if (date.weekday == DateTime.sunday) {
      double increasePrice = valueInt + 50000;

      return UtilsMethod.formatMoney(increasePrice);
    } else {
      return UtilsMethod.formatMoney(valueInt);
    }
  }

  // Format price into double
  double _getPriceDouble(DateTime date, String basePriceStr) {
    double valueInt = double.parse(basePriceStr);

    if (date.weekday == DateTime.sunday) {
      double increasePrice = valueInt + 50000;

      return increasePrice;
    } else {
      return valueInt;
    }
  }

  @override
  void initState() {
    super.initState();
    // Auto grenerate next 7 days
    _generateNext7Days();

    selectedPrice = double.parse(widget.price); // default price
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            "Thời gian làm việc",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 4),

          // Subtitle
          const Text(
            "Giá dịch vụ có thể thay đổi tùy thuộc vào ngày giờ bạn chọn",
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),

          const SizedBox(height: 12),

          // List days
          SizedBox(
            height: 130,
            child: ListView.builder(
              scrollDirection: Axis.horizontal, //Scroll horizontal
              itemCount: next7Days.length,
              // Render
              itemBuilder: (context, index) {
                final date = next7Days[index];
                final isSelected = index == selectedIndex; //Return T2, T3, T4
                final dayLabel = _getWeekdayShort(date);
                final formattedDate = DateFormat(
                  "dd/MM",
                ).format(date); //Format date
                final price = _getPrice(date, widget.price);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                      selectedPrice = _getPriceDouble(date, widget.price);

                      // Add 7 days to selected day
                      recurringEndDate = isRecurring
                          ? next7Days[selectedIndex].add(
                              const Duration(days: 7),
                            )
                          : null;
                    });

                    // Pass price data into parent widget
                    widget.onPriceChanged?.call(selectedPrice, date);
                  },
                  child: Container(
                    width: 100,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      //Color
                      color: isSelected ? Colors.yellow[100] : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.amber : Colors.grey.shade300,
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Day
                        Text(
                          dayLabel,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.orange : Colors.black,
                          ),
                        ),

                        // Day format dd/mm
                        Text(
                          formattedDate,
                          style: const TextStyle(fontSize: 13),
                        ),

                        // Price
                        Text(
                          price,
                          style: TextStyle(
                            fontSize: 13,
                            color: isSelected ? Colors.orange : Colors.green,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Start time
          Row(
            children: [
              // Icon
              const Icon(Icons.access_time, color: Colors.grey),

              const SizedBox(width: 8),

              // Title
              const Text(
                "Giờ bắt đầu:",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),

              const SizedBox(width: 8),

              // Dropdown start time
              Expanded(
                child: DropdownButtonFormField<TimeOfDay>(
                  // Decoration
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.access_time),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.orange),
                    ),
                  ),

                  value: selectedStartTime,
                  // Create 13 items
                  items: List.generate(13, (i) {
                    final time = TimeOfDay(hour: 6 + i, minute: 0);

                    return DropdownMenuItem(
                      value: time,
                      child: Text("${time.hour.toString().padLeft(2, '0')}:00"),
                    );
                  }),

                  onChanged: (valueStartTime) {
                    setState(() => selectedStartTime = valueStartTime!);

                    // If start time >= end time => increase end time 1 hour
                    if (selectedEndTime == null ||
                        selectedEndTime!.hour <= selectedStartTime!.hour) {
                      setState(() {
                        selectedEndTime = TimeOfDay(
                          hour: selectedStartTime!.hour + 1,
                          minute: 0,
                        );
                      });
                    }

                    // Pass start time data into parent widget
                    widget.onStartTimeChanged?.call(valueStartTime!);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          //  End time dropdown
          Row(
            children: [
              // Icon
              const Icon(Icons.timelapse, color: Colors.grey),

              const SizedBox(width: 8),

              // Title
              const Text(
                "Giờ kết thúc:",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),

              const SizedBox(width: 8),

              // Dropdown end time
              Expanded(
                child: DropdownButtonFormField<TimeOfDay>(
                  // Decoration
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.access_time),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.orange),
                    ),
                  ),

                  value: selectedEndTime,
                  // Create 13 items
                  items: List.generate(13, (i) {
                    final time = TimeOfDay(hour: 6 + i, minute: 0);

                    return DropdownMenuItem(
                      value: time,
                      child: Text("${time.hour.toString().padLeft(2, '0')}:00"),
                    );
                  }),

                  onChanged: (valueEndtime) {
                    // Need to choose start time first
                    if (selectedStartTime == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Vui lòng chọn giờ bắt đầu trước"),
                        ),
                      );
                      return;
                    }

                    // Only allow end time that > start time
                    if (valueEndtime!.hour <= selectedStartTime!.hour) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Giờ kết thúc phải lớn hơn giờ bắt đầu!",
                          ),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    setState(() => selectedEndTime = valueEndtime);

                    // Pass end time data into parent widget
                    widget.onEndTimeChanged?.call(valueEndtime);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          //  Recurring
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  // Text
                  Text(
                    "Lặp lại vào tuần sau",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  ),

                  SizedBox(width: 4),

                  // Icon
                  Icon(Icons.info_outline, size: 16, color: Colors.grey),
                ],
              ),

              // Toggle button
              Switch(
                value: isRecurring,
                activeColor: Colors.amber,
                onChanged: (value) {
                  setState(() => isRecurring = value);

                  // Add 7 days to current day
                  recurringEndDate = isRecurring
                      ? next7Days[selectedIndex].add(const Duration(days: 7))
                      : null;

                  // Pass recurring data into parent widget
                  widget.onRecurringChanged?.call(
                    isRecurring,
                    recurringEndDate,
                  );
                },
              ),
            ],
          ),

          // End date recursion ui
          if (isRecurring && recurringEndDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 4),
              child: Row(
                children: [
                  // Icon
                  const Icon(Icons.event, color: Colors.grey, size: 20),

                  const SizedBox(width: 8),

                  // Text
                  Text(
                    "Ngày kết thúc lặp lại: ${DateFormat('dd/MM/yyyy').format(recurringEndDate!)}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
