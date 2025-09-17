import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_b1/model/todo_model.dart';
import 'package:todo_b1/widgets/emphy_widget.dart';
import 'package:todo_b1/widgets/search_bar.dart';
import 'package:todo_b1/widgets/todo_status.dart';
import 'package:todo_b1/widgets/typing_quotes.dart';
import '../core/colors.dart';
import '../bloc/todo_bloc.dart';
import '../bloc/todo_event.dart';
import '../bloc/todo_state.dart';
import '../widgets/todo_item_widget.dart';
import '../widgets/todo_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<TodoBloc>().add(LoadTodos());
  }

  void _addTodo() {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) return;

    context.read<TodoBloc>().add(AddTodo(title: title, description: desc));
    _clearControllersAndPop();
  }

  void _updateTodo(TodoModel todo) {
    final title = _titleController.text.trim();
    final desc = _descController.text.trim();

    if (title.isEmpty) return;

    context.read<TodoBloc>().add(
      UpdateTodo(
        todo.copyWith(
          title: title,
          description: desc,
          updatedAt: DateTime.now(),
        ),
      ),
    );
    _clearControllersAndPop();
  }

  void _clearControllersAndPop() {
    _titleController.clear();
    _descController.clear();
    Navigator.pop(context);
  }

  void _showAddDialog() {
    _showTodoDialog(title: "Add Todo", confirmText: "Add", onConfirm: _addTodo);
  }

  void _showEditDialog(TodoModel todo) {
    _titleController.text = todo.title;
    _descController.text = todo.description;

    _showTodoDialog(
      title: "Edit Todo",
      confirmText: "Save",
      onConfirm: () => _updateTodo(todo),
    );
  }

  void _showTodoDialog({
    required String title,
    required String confirmText,
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder:
          (context) => TodoDialog(
            title: title,
            confirmText: confirmText,
            titleController: _titleController,
            descController: _descController,
            onConfirm: onConfirm,
            onCancel: () {
              _titleController.clear();
              _descController.clear();
              Navigator.pop(context);
            },
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: surface,
      // Add this to prevent automatic resize when keyboard appears
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        // Wrap the entire body with SingleChildScrollView
        child: SizedBox(
          height: MediaQuery.of(context).size.height, // Set explicit height
          child: Column(
            children: [
              // Pure Black Section with Typing Quotes
              const TypingQuotesWidget(),

              // Main Content Section
              Expanded(
                child: Container(
                  width: double.infinity,
                  color: surface,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        // Search and Add Bar
                        SearchAndAddBar(
                          searchController: _searchController,
                          onAddPressed: _showAddDialog,
                        ),
                        const SizedBox(height: 24),

                        // BLoC Consumer for Todo List
                        Expanded(
                          child: BlocConsumer<TodoBloc, TodoState>(
                            listener: (context, state) {
                              if (state is TodoError) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.message),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state is TodoLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (state is TodoLoaded) {
                                return Column(
                                  children: [
                                    // Status Row
                                    TodoStatusRow(
                                      pendingCount: state.pendingCount,
                                      completedCount: state.completedCount,
                                      totalCount: state.todos.length,
                                    ),
                                    const SizedBox(height: 20),

                                    // Todo List
                                    Expanded(
                                      child:
                                          state.filteredTodos.isEmpty
                                              ? const EmptyStateWidget()
                                              : ListView.builder(
                                                itemCount:
                                                    state.filteredTodos.length,
                                                itemBuilder: (context, index) {
                                                  final todo =
                                                      state
                                                          .filteredTodos[index];
                                                  return TodoItemWidget(
                                                    todo: todo,
                                                    onEdit:
                                                        () => _showEditDialog(
                                                          todo,
                                                        ),
                                                  );
                                                },
                                              ),
                                    ),
                                  ],
                                );
                              }

                              return const Center(
                                child: Text(
                                  "Something went wrong",
                                  style: TextStyle(
                                    color: onSurface,
                                    fontSize: 16,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
