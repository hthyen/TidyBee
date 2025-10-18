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

    _descriptionController = TextEditingController(
      text: widget.helper.description ?? '',
    );
    _experienceController = TextEditingController(
      text: widget.helper.experience ?? '',
    );
    _languagesController = TextEditingController(
      text: widget.helper.languages ?? '',
    );

    // Assign location values if available, otherwise empty
    final loc = widget.helper.locationData;
    _addressController = TextEditingController(text: loc?['address'] ?? '');
    _cityController = TextEditingController(text: loc?['city'] ?? '');
    _districtController = TextEditingController(text: loc?['district'] ?? '');
    _wardController = TextEditingController(text: loc?['ward'] ?? '');
    _latitudeController = TextEditingController(
      text: (loc?['latitude'] ?? 0).toString(),
    );
    _longitudeController = TextEditingController(
      text: (loc?['longitude'] ?? 0).toString(),
    );
  }

  Future<void> _savePersonalInfo() async {
    if (!_formKey.currentState!.validate()) return;

    // Normalize data before sending to server in correct format
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
      widget.token,
      updateData,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("✅ Cập nhật thông tin cá nhân thành công"),
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
        title: const Text("Chỉnh sửa thông tin cá nhân"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              /// Description
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Mô tả"),
              ),
              const SizedBox(height: 10),

              /// Experience
              TextFormField(
                controller: _experienceController,
                decoration: const InputDecoration(labelText: "Kinh nghiệm"),
              ),
              const SizedBox(height: 10),

              /// Languages
              TextFormField(
                controller: _languagesController,
                decoration: const InputDecoration(labelText: "Ngôn ngữ"),
              ),
              const SizedBox(height: 20),

              const Text(
                "📍 Thông tin khu vực làm việc",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Địa chỉ cụ thể"),
              ),
              TextFormField(
                controller: _cityController,
                decoration: const InputDecoration(labelText: "Thành phố"),
              ),
              TextFormField(
                controller: _districtController,
                decoration: const InputDecoration(labelText: "Quận/Huyện"),
              ),
              TextFormField(
                controller: _wardController,
                decoration: const InputDecoration(labelText: "Phường/Xã"),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitudeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Vĩ độ (latitude)",
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Kinh độ (longitude)",
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              ElevatedButton.icon(
                onPressed: _savePersonalInfo,
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
}
