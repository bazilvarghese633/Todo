import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/colors.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';

class SearchAndAddBar extends StatelessWidget {
  final TextEditingController searchController;
  final VoidCallback onAddPressed;

  const SearchAndAddBar({
    super.key,
    required this.searchController,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF2A2A2A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: searchController,
              style: const TextStyle(color: onSurface),
              onChanged: (query) {
                context.read<TodoBloc>().add(FilterTodos(query));
              },
              decoration: const InputDecoration(
                hintText: "🚀 Search...",
                hintStyle: TextStyle(color: Colors.grey),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 50,
          width: 80,
          decoration: BoxDecoration(
            color: primary,
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextButton(
            onPressed: onAddPressed,
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Add",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 4),
                Icon(Icons.add, color: Colors.white, size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
