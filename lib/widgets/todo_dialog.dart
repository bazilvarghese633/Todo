import 'package:flutter/material.dart';
import '../core/colors.dart';

class TodoDialog extends StatelessWidget {
  final String title;
  final String confirmText;
  final TextEditingController titleController;
  final TextEditingController descController;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const TodoDialog({
    super.key,
    required this.title,
    required this.confirmText,
    required this.titleController,
    required this.descController,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: const TextStyle(color: onSurface, fontWeight: FontWeight.w600),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTextField(
            controller: titleController,
            labelText: "Title",
            maxLines: 1,
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: descController,
            labelText: "Description",
            maxLines: 3,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text("Cancel", style: TextStyle(color: primary)),
        ),
        Container(
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextButton(
            onPressed: onConfirm,
            child: Text(
              confirmText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required int maxLines,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: onSurface.withOpacity(0.2)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: onSurface),
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: onSurface),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}
