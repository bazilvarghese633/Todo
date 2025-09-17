import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_b1/model/todo_model.dart';
import '../core/colors.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';

class TodoItemWidget extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback onEdit;

  const TodoItemWidget({super.key, required this.todo, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CupertinoCheckbox(
          value: todo.isDone,
          activeColor: primary,
          onChanged: (value) {
            context.read<TodoBloc>().add(
              ToggleTodoStatus(todoId: todo.id, isDone: value ?? false),
            );
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            color: onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle:
            todo.description.isNotEmpty
                ? Text(
                  todo.description,
                  style: TextStyle(
                    color: onSurface.withOpacity(0.7),
                    fontSize: 14,
                    decoration: todo.isDone ? TextDecoration.lineThrough : null,
                  ),
                )
                : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.grey),
              onPressed: () {
                context.read<TodoBloc>().add(DeleteTodo(todo.id));
              },
            ),
          ],
        ),
      ),
    );
  }
}
