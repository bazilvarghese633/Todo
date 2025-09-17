import 'package:flutter/material.dart';
import '../core/colors.dart';

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.content_paste,
            size: 64,
            color: onSurface.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            "You don't have any tasks yet.",
            style: TextStyle(
              color: onSurface.withOpacity(0.7),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Start adding tasks and manage your\ntime effectively.",
            textAlign: TextAlign.center,
            style: TextStyle(color: onSurface.withOpacity(0.5), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
