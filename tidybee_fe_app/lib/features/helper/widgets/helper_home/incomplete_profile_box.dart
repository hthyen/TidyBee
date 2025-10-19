import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/features/helper/model/helper.dart';

class IncompleteProfileBox extends StatelessWidget {
  final Helper helper;
  final String token;

  const IncompleteProfileBox({
    super.key,
    required this.helper,
    required this.token,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orangeAccent),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.orangeAccent,
            size: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Hoàn thiện hồ sơ để được kiểm duyệt!",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orangeAccent,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Hồ sơ của bạn chưa đầy đủ. Hãy cập nhật mô tả, kinh nghiệm, ngôn ngữ và khu vực để được duyệt làm cộng tác viên.",
                  style: TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    context.pushNamed(
                      "edit-helper-personal",
                      extra: {"token": token, "helper": helper},
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Cập nhật hồ sơ ngay",
                    style: TextStyle(color: Colors.white),
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
