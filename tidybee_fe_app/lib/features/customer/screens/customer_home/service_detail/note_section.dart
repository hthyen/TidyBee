import 'package:flutter/material.dart';

class NoteSection extends StatefulWidget {
  final Function(String note)? onChanged;

  const NoteSection({super.key, this.onChanged});

  @override
  State<NoteSection> createState() => _NoteSectionState();
}

class _NoteSectionState extends State<NoteSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            "Ghi chú thêm",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),

          const SizedBox(height: 8),

          // Input note
          TextField(
            controller: _controller,
            maxLines: 5,
            decoration: InputDecoration(
              hintText:
                  "Ví dụ: Nhà có thú cưng, cần mang dụng cụ riêng, giờ nghỉ trưa,...",
              hintStyle: TextStyle(color: Colors.grey[500]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.orange, width: 1.5),
              ),
              contentPadding: const EdgeInsets.all(12),
            ),

            onChanged: (value) {
              if (widget.onChanged != null) {
                widget.onChanged!(value);
              }
              ;
            },
          ),
        ],
      ),
    );
  }
}
