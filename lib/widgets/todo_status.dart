import 'package:flutter/material.dart';
import '../core/colors.dart';

class TodoStatusRow extends StatelessWidget {
  final int pendingCount;
  final int completedCount;
  final int totalCount;

  const TodoStatusRow({
    super.key,
    required this.pendingCount,
    required this.completedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "Pending",
          style: TextStyle(
            color: primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "$pendingCount",
            style: TextStyle(
              color: primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Spacer(),
        Text(
          "Completed",
          style: TextStyle(
            color: primary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: primary.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            "$completedCount/$totalCount",
            style: TextStyle(
              color: primary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
