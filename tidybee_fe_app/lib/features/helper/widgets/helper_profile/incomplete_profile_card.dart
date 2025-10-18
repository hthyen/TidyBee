import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/features/helper/model/helper.dart';

class IncompleteProfileCard extends StatelessWidget {
  final Helper helper;
  final String token;
  final VoidCallback onUpdated;

  const IncompleteProfileCard({
    super.key,
    required this.helper,
    required this.token,
    required this.onUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.orange.shade50,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 28,
                ),
                SizedBox(width: 8),
                Text(
                  'Hồ sơ chưa hoàn chỉnh',
                  style: TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Vui lòng cập nhật đầy đủ thông tin cá nhân và công việc để hồ sơ của bạn được duyệt.',
              style: TextStyle(fontSize: 14, color: Colors.black87),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () async {
                final choice = await showModalBottomSheet<String>(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (ctx) => SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Chọn loại thông tin cần cập nhật",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            leading: const Icon(
                              Icons.person,
                              color: Colors.blueAccent,
                            ),
                            title: const Text("Cập nhật thông tin cá nhân"),
                            onTap: () => Navigator.pop(ctx, "personal"),
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.work,
                              color: Colors.green,
                            ),
                            title: const Text("Cập nhật thông tin công việc"),
                            onTap: () => Navigator.pop(ctx, "work"),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                if (choice == "personal") {
                  context
                      .pushNamed(
                        "edit-helper-personal",
                        extra: {"token": token, "helper": helper},
                      )
                      .then((updated) {
                        if (updated == true) onUpdated();
                      });
                } else if (choice == "work") {
                  context
                      .pushNamed(
                        "edit-helper-work",
                        extra: {"token": token, "helper": helper},
                      )
                      .then((updated) {
                        if (updated == true) onUpdated();
                      });
                }
              },
              icon: const Icon(Icons.edit, color: Colors.white),
              label: const Text(
                'Cập nhật hồ sơ ngay',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
