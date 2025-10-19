import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';

class HomeServices extends StatefulWidget {
  const HomeServices({super.key});

  @override
  State<HomeServices> createState() => _HomeServicesState();
}

class _HomeServicesState extends State<HomeServices> {
  final services = [
    {
      "id": 1,
      "title": "Dọn dẹp nhà cửa",
      "icon": Icons.cleaning_services_outlined,
      "price": "180000",
      "description":
          "Dịch vụ dọn dẹp, lau chùi toàn bộ không gian nhà, giúp bạn tiết kiệm thời gian và luôn có tổ ấm sạch sẽ.",
    },
    {
      "id": 2,
      "title": "Nấu ăn tại nhà",
      "icon": Icons.restaurant_outlined,
      "price": "250000",
      "description":
          "Đầu bếp đến tận nhà chuẩn bị bữa ăn ngon miệng, hợp khẩu vị cho gia đình bạn.",
    },
    {
      "id": 3,
      "title": "Trông trẻ",
      "icon": Icons.child_friendly_outlined,
      "price": "200000",
      "description":
          "Người trông trẻ tận tâm, có kinh nghiệm chăm sóc và vui chơi cùng bé an toàn, chu đáo.",
    },
    {
      "id": 4,
      "title": "Chăm sóc người già",
      "icon": Icons.elderly_outlined,
      "price": "220000",
      "description":
          "Nhân viên tận tâm hỗ trợ sinh hoạt, theo dõi sức khỏe và trò chuyện cùng người cao tuổi.",
    },
    {
      "id": 5,
      "title": "Chăm sóc vườn",
      "icon": Icons.yard_outlined,
      "price": "150000",
      "description":
          "Tưới cây, tỉa cành, cắt cỏ và chăm sóc khu vườn của bạn luôn xanh tươi, gọn gàng.",
    },
    {
      "id": 6,
      "title": "Chăm sóc thú cưng",
      "icon": Icons.pets_outlined,
      "price": "120000",
      "description":
          "Tắm rửa, cho ăn và chơi cùng thú cưng của bạn khi bạn bận rộn hoặc đi vắng.",
    },
    {
      "id": 7,
      "title": "Giặt ủi",
      "icon": Icons.local_laundry_service_outlined,
      "price": "80000",
      "description":
          "Giặt, sấy và ủi quần áo gọn gàng, sạch thơm, giúp bạn tiết kiệm thời gian mỗi ngày.",
    },
    {
      "id": 8,
      "title": "Chuyển nhà",
      "icon": Icons.local_shipping_outlined,
      "price": "500000",
      "description":
          "Đội ngũ chuyển nhà chuyên nghiệp hỗ trợ đóng gói, vận chuyển an toàn, nhanh chóng.",
    },
    {
      "id": 9,
      "title": "Sửa chữa & bảo trì",
      "icon": Icons.build_outlined,
      "price": "250000",
      "description":
          "Thợ lành nghề hỗ trợ sửa chữa điện, nước, thiết bị gia dụng, bảo trì định kỳ.",
    },
    {
      "id": 10,
      "title": "Dịch vụ khác",
      "icon": Icons.more_horiz_outlined,
      "price": "0",
      "description":
          "Nếu bạn cần dịch vụ đặc biệt khác, hãy liên hệ để được tư vấn và báo giá cụ thể.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header + Button view all
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Text
                const Text(
                  "Dịch vụ",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),

                // Button
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

            // GridView - fixed overflow
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, //items per row
                crossAxisSpacing: 12,
                mainAxisSpacing: 16, //Margin bottom
                childAspectRatio: 0.5, //width
              ),
              itemBuilder: (context, index) {
                final service = services[index];
                //Navigate to detail
                return GestureDetector(
                  onTap: () {
                    context.push(
                      "/customer-service-detail",
                      extra: {
                        "id": service["id"],
                        "title": service["title"],
                        "price": service["price"],
                        "description": service["description"],
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Service
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

                        // Text
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
                );
              },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
