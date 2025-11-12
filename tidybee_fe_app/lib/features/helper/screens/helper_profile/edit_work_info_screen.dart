import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/core/common_widgets/notification_service.dart';
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
  final _helperServices = HelperServices();

  late TextEditingController _hourlyRateController;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  late List<int> _selectedServiceIds;
  late List<int> _selectedDayInts;

  static const _serviceMap = {
    1: "Dọn dẹp nhà cửa",
    2: "Nấu ăn",
    3: "Trông trẻ",
    4: "Chăm sóc người già",
    5: "Chăm sóc vườn",
    6: "Chăm sóc thú cưng",
    7: "Giặt ủi",
    8: "Chuyển nhà",
    9: "Bảo trì, sửa chữa",
    10: "Khác",
  };
  static const _weekDays = [
    "Thứ 2",
    "Thứ 3",
    "Thứ 4",
    "Thứ 5",
    "Thứ 6",
    "Thứ 7",
    "Chủ nhật",
  ];

  @override
  void initState() {
    super.initState();
    final h = widget.helper;
    _hourlyRateController = TextEditingController(
      text: h.hourlyRate?.toString() ?? '',
    );
    _startTime = _parseTime(h.workingHoursStart);
    _endTime = _parseTime(h.workingHoursEnd);
    _selectedServiceIds = List.from(h.services ?? []);
    _selectedDayInts = List.from(h.workingDays ?? []);
  }

  @override
  void dispose() {
    _hourlyRateController.dispose();
    super.dispose();
  }

  TimeOfDay? _parseTime(String? t) {
    if (t == null || t.isEmpty) return null;
    final p = t.split(':');
    if (p.length < 2) return null;
    final h = int.tryParse(p[0]) ?? 0;
    final m = int.tryParse(p[1]) ?? 0;
    return TimeOfDay(hour: h, minute: m);
  }

  String _formatTime(TimeOfDay? t) => t == null
      ? '--:--'
      : '${t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod}:${t.minute.toString().padLeft(2, '0')} ${t.period == DayPeriod.am ? 'AM' : 'PM'}';

  String _formatTime24h(TimeOfDay t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:00';

  bool _isValidTime() {
    if (_startTime == null || _endTime == null) return false;
    return (_endTime!.hour * 60 + _endTime!.minute) >
        (_startTime!.hour * 60 + _startTime!.minute);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_isValidTime()) {
      NotificationService.showError(
        context,
        "Giờ kết thúc phải sau giờ bắt đầu",
      );
      return;
    }

    final h = widget.helper;
    final rate =
        double.tryParse(_hourlyRateController.text) ?? h.hourlyRate ?? 100000;

    final data = {
      "description": h.description?.trim().isNotEmpty == true
          ? h.description!
          : "Chưa có mô tả",
      "hourlyRate": rate,
      "services": _selectedServiceIds,
      "workingHoursStart": _formatTime24h(_startTime!),
      "workingHoursEnd": _formatTime24h(_endTime!),
      "workingDays": _selectedDayInts,
      "experience": h.experience ?? "",
      "languages": h.languages ?? "",
      "location":
          h.location ??
          {
            "latitude": 0,
            "longitude": 0,
            "address": "",
            "city": "",
            "district": "",
            "ward": "",
          },
    };

    final success = await _helperServices.updateHelper(
      token: widget.token,
      updateData: data,
    );
    if (!mounted) return;

    success
        ? NotificationService.showSuccess(context, "Cập nhật thành công")
        : NotificationService.showError(context, "Cập nhật thất bại");

    if (success) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Thông tin công việc"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Container(
        color: Colors.grey[50],
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _section("Giá theo giờ"),
              _textField(
                _hourlyRateController,
                "Nhập giá (VNĐ)",
                suffix: "VNĐ",
                validator: (v) =>
                    v?.isEmpty == true || (double.tryParse(v!) ?? 0) <= 0
                    ? "Giá phải lớn hơn 0 nhé"
                    : null,
              ),
              const SizedBox(height: 24),

              _section("Dịch vụ cung cấp"),
              _chips(
                _serviceMap,
                _selectedServiceIds,
                (id) => setState(() => _toggle(_selectedServiceIds, id)),
              ),
              const SizedBox(height: 24),

              _section("Giờ làm việc"),
              Row(
                children: [
                  Expanded(child: _buildTimeDropdown(true)),
                  const SizedBox(width: 16),
                  const Icon(Icons.arrow_forward, color: Colors.grey),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTimeDropdown(false)),
                ],
              ),
              const SizedBox(height: 24),

              _section("Ngày làm việc"),
              _chips(
                Map.fromIterables(List.generate(7, (i) => i + 1), _weekDays),
                _selectedDayInts,
                (id) => setState(() => _toggle(_selectedDayInts, id)),
              ),
              const SizedBox(height: 32),

              ElevatedButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: const Text("Lưu thay đổi"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  // Widgets
  Widget _section(String t) => Text(
    t,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
  );
  void _toggle(List<int> l, int id) =>
      setState(() => l.contains(id) ? l.remove(id) : l.add(id));

  Widget _textField(
    TextEditingController c,
    String l, {
    String? suffix,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: c,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: l,
      suffixText: suffix,
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    ),
    validator: validator,
  );

  Widget _chips(Map<int, String> map, List<int> sel, Function(int) onTap) =>
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: map.entries.map((e) {
          final s = sel.contains(e.key);
          return FilterChip(
            label: Text(
              e.value,
              style: TextStyle(
                fontWeight: s ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            selected: s,
            onSelected: (_) => onTap(e.key),
            selectedColor: AppColors.primary.withOpacity(0.2),
            checkmarkColor: AppColors.primary,
            backgroundColor: Colors.white,
            shape: StadiumBorder(
              side: BorderSide(
                color: s ? AppColors.primary : Colors.grey[300]!,
                width: 1.5,
              ),
            ),
          );
        }).toList(),
      );

  Widget _buildTimeDropdown(bool isStart) {
    final time = isStart ? _startTime : _endTime;
    final label = isStart ? "Bắt đầu" : "Kết thúc";

    final List<TimeOfDay> timeOptions = [];
    for (int h = 0; h < 24; h++) {
      for (int m = 0; m < 60; m += 15) {
        timeOptions.add(TimeOfDay(hour: h, minute: m));
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: time != null ? AppColors.primary : Colors.grey[300]!,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<TimeOfDay>(
              value: time,
              hint: Text("Chọn giờ", style: TextStyle(color: Colors.grey[500])),
              isExpanded: true,
              icon: Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
              dropdownColor: Colors.white,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
              items: timeOptions.map((t) {
                return DropdownMenuItem(value: t, child: Text(_formatTime(t)));
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    if (isStart)
                      _startTime = value;
                    else
                      _endTime = value;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}
