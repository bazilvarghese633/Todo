// lib/bloc/todo_state.dart
import 'package:equatable/equatable.dart';
import 'package:todo_b1/model/todo_model.dart';

abstract class TodoState extends Equatable {
  const TodoState();

  @override
  List<Object> get props => [];
}

class TodoInitial extends TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<TodoModel> todos;
  final List<TodoModel> filteredTodos;
  final String searchQuery;

  const TodoLoaded({
    required this.todos,
    required this.filteredTodos,
    this.searchQuery = '',
  });

  TodoLoaded copyWith({
    List<TodoModel>? todos,
    List<TodoModel>? filteredTodos,
    String? searchQuery,
  }) {
    return TodoLoaded(
      todos: todos ?? this.todos,
      filteredTodos: filteredTodos ?? this.filteredTodos,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  int get pendingCount => todos.where((todo) => !todo.isDone).length;
  int get completedCount => todos.where((todo) => todo.isDone).length;

  @override
  List<Object> get props => [todos, filteredTodos, searchQuery];
}

class TodoError extends TodoState {
  final String message;

  const TodoError(this.message);

  @override
  List<Object> get props => [message];
}
