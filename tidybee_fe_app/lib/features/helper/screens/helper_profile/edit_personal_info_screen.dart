import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/features/helper/model/helper.dart';
import 'package:tidybee_fe_app/features/helper/services/helper_services.dart';

class EditPersonalInfoScreen extends StatefulWidget {
  final Helper helper;
  final String token;

  const EditPersonalInfoScreen({
    super.key,
    required this.helper,
    required this.token,
  });

  @override
  State<EditPersonalInfoScreen> createState() => _EditPersonalInfoScreenState();
}

class _EditPersonalInfoScreenState extends State<EditPersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final HelperServices _helperServices = HelperServices();

  late TextEditingController _descriptionController;
  late TextEditingController _experienceController;
  late TextEditingController _languagesController;

  // Location fields
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _districtController;
  late TextEditingController _wardController;
  late TextEditingController _latitudeController;
  late TextEditingController _longitudeController;

  @override
  void initState() {
    super.initState();

    // 1. Text fields
    _descriptionController = TextEditingController(
      text: widget.helper.description ?? '',
    );
    _experienceController = TextEditingController(
      text: widget.helper.experience ?? '',
    );
    _languagesController = TextEditingController(
      text: widget.helper.languages ?? '',
    );

    // 2. Location:
    final loc = widget.helper.location;

    _addressController = TextEditingController(
      text: loc?['address']?.toString() ?? '',
    );
    _cityController = TextEditingController(
      text: loc?['city']?.toString() ?? '',
    );
    _districtController = TextEditingController(
      text: loc?['district']?.toString() ?? '',
    );
    _wardController = TextEditingController(
      text: loc?['ward']?.toString() ?? '',
    );

    _latitudeController = TextEditingController(
      text: loc?['latitude'] != null ? loc!['latitude'].toString() : '',
    );
    _longitudeController = TextEditingController(
      text: loc?['longitude'] != null ? loc!['longitude'].toString() : '',
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _experienceController.dispose();
    _languagesController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _wardController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _savePersonalInfo() async {
    if (!_formKey.currentState!.validate()) return;

    final updateData = {
      "description": _descriptionController.text.trim(),
      "experience": _experienceController.text.trim(),
      "languages": _languagesController.text.trim(),
      "location": {
        "latitude": double.tryParse(_latitudeController.text) ?? 0.0,
        "longitude": double.tryParse(_longitudeController.text) ?? 0.0,
        "address": _addressController.text.trim(),
        "city": _cityController.text.trim(),
        "district": _districtController.text.trim(),
        "ward": _wardController.text.trim(),
      },
    };

    final success = await _helperServices.updateHelper(
      token: widget.token,
      updateData: updateData,
    );

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cập nhật thông tin cá nhân thành công")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Cập nhật thất bại")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chỉnh sửa thông tin cá nhân"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// Mô tả
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Mô tả",
                  hintText:
                      "Ví dụ: Tôi chuyên dọn nhà, giặt thảm, vệ sinh máy lạnh...",
                ),
                maxLines: 3,
                validator: (value) => value?.trim().isEmpty == true
                    ? 'Vui lòng nhập mô tả'
                    : null,
              ),
              const SizedBox(height: 16),

              /// Kinh nghiệm
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(
                  labelText: "Kinh nghiệm",
                  hintText:
                      "Ví dụ: 3 năm làm việc tại các hộ gia đình và văn phòng",
                ),
                validator: (value) => value?.trim().isEmpty == true
                    ? 'Vui lòng nhập kinh nghiệm'
                    : null,
              ),
              const SizedBox(height: 16),

              /// Ngôn ngữ
              TextFormField(
                controller: _languagesController,
                decoration: const InputDecoration(
                  labelText: "Ngôn ngữ",
                  hintText: "Ví dụ: Tiếng Việt, Tiếng Anh giao tiếp",
                ),
                validator: (value) => value?.trim().isEmpty == true
                    ? 'Vui lòng nhập ngôn ngữ'
                    : null,
              ),
              const SizedBox(height: 24),

              const Text(
                "Thông tin khu vực làm việc",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(height: 20, thickness: 1),

              /// Địa chỉ
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Địa chỉ cụ thể"),
                validator: (value) => value?.trim().isEmpty == true
                    ? 'Vui lòng nhập địa chỉ'
                    : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(labelText: "Thành phố"),
                      validator: (value) => value?.trim().isEmpty == true
                          ? 'Vui lòng nhập thành phố'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _districtController,
                      decoration: const InputDecoration(
                        labelText: "Quận/Huyện",
                      ),
                      validator: (value) => value?.trim().isEmpty == true
                          ? 'Vui lòng nhập quận'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _wardController,
                decoration: const InputDecoration(labelText: "Phường/Xã"),
                validator: (value) => value?.trim().isEmpty == true
                    ? 'Vui lòng nhập phường'
                    : null,
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitudeController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Vĩ độ (latitude)",
                        hintText: "10.7769",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty)
                          return 'Bắt buộc';
                        final lat = double.tryParse(value);
                        if (lat == null || lat < -90 || lat > 90)
                          return 'Vĩ độ không hợp lệ';
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Kinh độ (longitude)",
                        hintText: "106.7009",
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty)
                          return 'Bắt buộc';
                        final lng = double.tryParse(value);
                        if (lng == null || lng < -180 || lng > 180)
                          return 'Kinh độ không hợp lệ';
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              /// Nút lưu
              ElevatedButton.icon(
                onPressed: _savePersonalInfo,
                icon: const Icon(Icons.save),
                label: const Text("Lưu thay đổi"),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
