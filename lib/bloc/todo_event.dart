// lib/bloc/todo_event.dart
import 'package:equatable/equatable.dart';
import 'package:todo_b1/model/todo_model.dart';

abstract class TodoEvent extends Equatable {
  const TodoEvent();

  @override
  List<Object> get props => [];
}

class LoadTodos extends TodoEvent {}

class AddTodo extends TodoEvent {
  final String title;
  final String description;

  const AddTodo({required this.title, required this.description});

  @override
  List<Object> get props => [title, description];
}

class UpdateTodo extends TodoEvent {
  final TodoModel todo;

  const UpdateTodo(this.todo);

  @override
  List<Object> get props => [todo];
}

class DeleteTodo extends TodoEvent {
  final String todoId;

  const DeleteTodo(this.todoId);

  @override
  List<Object> get props => [todoId];
}

class ToggleTodoStatus extends TodoEvent {
  final String todoId;
  final bool isDone;

  const ToggleTodoStatus({required this.todoId, required this.isDone});

  @override
  List<Object> get props => [todoId, isDone];
}

class FilterTodos extends TodoEvent {
  final String query;

  const FilterTodos(this.query);

  @override
  List<Object> get props => [query];
}
