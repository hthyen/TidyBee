import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final addresses = [
      '123 Đường ABC, Quận 1, TP.HCM',
      '456 Đường XYZ, Quận 3, TP.HCM',
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Địa chỉ của tôi'), centerTitle: true),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: addresses.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.location_on_outlined, color: Colors.red),
            title: Text(addresses[index]),
            trailing: IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {},
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
