import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/features/helper/model/helper.dart';
import 'package:tidybee_fe_app/features/helper/services/helper_services.dart';

class EditWorkInfoScreen extends StatefulWidget {
  final Helper helper;
  final String token;

  const EditWorkInfoScreen({
    super.key,
    required this.helper,
    required this.token,
  });

  @override
  State<EditWorkInfoScreen> createState() => _EditWorkInfoScreenState();
}

class _EditWorkInfoScreenState extends State<EditWorkInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final HelperServices _helperServices = HelperServices();

  late TextEditingController _hourlyRateController;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  final List<String> _availableServices = [
    "Giúp việc nhà",
    "Giặt ủi",
    "Nấu ăn",
    "Vệ sinh máy lạnh",
    "Dọn dẹp sau tiệc",
    "Chăm sóc người già",
    "Trông trẻ",
  ];

  final List<String> _weekDays = [
    "Thứ 2",
    "Thứ 3",
    "Thứ 4",
    "Thứ 5",
    "Thứ 6",
    "Thứ 7",
    "Chủ nhật",
  ];

  late List<String> _selectedServices;
  late List<String> _selectedDays;

  @override
  void initState() {
    super.initState();
    _hourlyRateController = TextEditingController(
      text: widget.helper.hourlyRate?.toString() ?? '',
    );

    _startTime = _parseTime(widget.helper.workingHoursStart);
    _endTime = _parseTime(widget.helper.workingHoursEnd);

    _selectedServices = List<String>.from(widget.helper.services ?? []);
    _selectedDays = List<String>.from(widget.helper.workingDays ?? []);
  }

  TimeOfDay? _parseTime(String? timeStr) {
    if (timeStr == null || timeStr.isEmpty) return null;
    final parts = timeStr.split(RegExp(r'[: ]'));
    if (parts.length < 2) return null;
    int hour = int.tryParse(parts[0]) ?? 0;
    int minute = int.tryParse(parts[1]) ?? 0;
    if (parts.length == 3 && parts[2].toLowerCase() == 'pm' && hour < 12) {
      hour += 12;
    }
    return TimeOfDay(hour: hour, minute: minute);
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart
        ? (_startTime ?? const TimeOfDay(hour: 8, minute: 0))
        : (_endTime ?? const TimeOfDay(hour: 17, minute: 0));

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      useRootNavigator: false,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  bool _isValidWorkingTime() {
    if (_startTime == null || _endTime == null) return false;

    final startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    final endMinutes = _endTime!.hour * 60 + _endTime!.minute;

    return endMinutes > startMinutes;
  }

  Future<void> _saveWorkInfo() async {
    if (!_formKey.currentState!.validate()) return;

    // Check valid working time
    if (_startTime == null || _endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Vui lòng chọn đầy đủ giờ làm việc")),
      );
      return;
    }

    if (!_isValidWorkingTime()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Giờ kết thúc phải sau giờ bắt đầu")),
      );
      return;
    }

    final updateData = {
      "hourlyRate": double.tryParse(_hourlyRateController.text) ?? 0,
      "services": _selectedServices,
      "workingHoursStart": _formatTime(_startTime),
      "workingHoursEnd": _formatTime(_endTime),
      "workingDays": _selectedDays,
    };

    final success = await _helperServices.updateHelper(
      widget.token,
      updateData,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Cập nhật thông tin công việc thành công"),
        ),
      );
      Navigator.pop(context, true);
    } else if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("❌ Cập nhật thất bại")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa thông tin công việc"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Hourly rate
              TextFormField(
                controller: _hourlyRateController,
                decoration: const InputDecoration(
                  labelText: "Giá theo giờ (VNĐ)",
                  suffixText: "VNĐ",
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),

              // Services provided
              const Text(
                "Dịch vụ cung cấp",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _availableServices.map((svc) {
                  final selected = _selectedServices.contains(svc);
                  return FilterChip(
                    label: Text(svc),
                    selected: selected,
                    onSelected: (bool value) {
                      setState(() {
                        value
                            ? _selectedServices.add(svc)
                            : _selectedServices.remove(svc);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Working hours
              const Text(
                "Giờ làm việc",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 360;
                  return isNarrow
                      ? Column(
                          children: [
                            _buildTimeButton(true),
                            const SizedBox(height: 8),
                            _buildTimeButton(false),
                          ],
                        )
                      : Row(
                          children: [
                            Expanded(child: _buildTimeButton(true)),
                            const SizedBox(width: 10),
                            Expanded(child: _buildTimeButton(false)),
                          ],
                        );
                },
              ),
              const SizedBox(height: 20),

              // Working days of week
              const Text(
                "Ngày làm việc trong tuần",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: _weekDays.map((day) {
                  final selected = _selectedDays.contains(day);
                  return FilterChip(
                    label: Text(day),
                    selected: selected,
                    onSelected: (bool value) {
                      setState(() {
                        value
                            ? _selectedDays.add(day)
                            : _selectedDays.remove(day);
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),

              // Save button
              ElevatedButton.icon(
                onPressed: _saveWorkInfo,
                icon: const Icon(Icons.save),
                label: const Text("Lưu thay đổi"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeButton(bool isStart) {
    final timeLabel = isStart
        ? "Bắt đầu: ${_formatTime(_startTime)}"
        : "Kết thúc: ${_formatTime(_endTime)}";
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      ),
      onPressed: () => _pickTime(isStart),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.access_time, size: 18),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              timeLabel,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
