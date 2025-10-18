import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';

class HomeServices extends StatefulWidget {
  const HomeServices({super.key});

  @override
  State<HomeServices> createState() => _HomeServicesState();
}

class _HomeServicesState extends State<HomeServices> {
  final services = [
    {"title": "Dọn dẹp nhà", "icon": Icons.cleaning_services_outlined},
    {"title": "Tổng vệ\nsinh", "icon": Icons.local_laundry_service_outlined},
    {"title": "Vệ sinh\nmáy lạnh", "icon": Icons.ac_unit_outlined},
    {"title": "Vệ sinh\nbếp", "icon": Icons.kitchen_outlined},
    {"title": "Trông Trẻ", "icon": Icons.child_friendly_outlined},
    {"title": "Vệ sinh\nvăn phòng", "icon": Icons.apartment_outlined},
    {"title": "Vệ sinh\nđệm", "icon": Icons.bed_outlined},
    {"title": "Vệ sinh\nmáy giặt", "icon": Icons.local_laundry_service},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header - Button view all
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              const Text(
                "Dịch vụ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              // Button view all
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "Xem tất cả",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Wrap to show all services of app
          // Wrap == flex
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            spacing: 8,
            runSpacing: 16,
            children: services.map((service) {
              return SizedBox(
                // MediaQuery: take size of device screen
                width: MediaQuery.of(context).size.width / 4.8,
                child: GestureDetector(
                  onTap: () {
                    // điều hướng sang chi tiết dịch vụ
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),

                          // Icon
                          child: Icon(
                            service["icon"] as IconData,
                            color: AppColors.primary,
                            size: 26,
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Title
                        Text(
                          service["title"] as String,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
