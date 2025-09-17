import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_b1/model/todo_model.dart';
import 'package:todo_b1/repository/todo_repo.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoRepository _todoRepository;
  StreamSubscription<List<TodoModel>>? _todosSubscription;

  TodoBloc({required TodoRepository todoRepository})
    : _todoRepository = todoRepository,
      super(TodoInitial()) {
    on<LoadTodos>(_onLoadTodos);
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
    on<ToggleTodoStatus>(_onToggleTodoStatus);
    on<FilterTodos>(_onFilterTodos);
    on<_TodosUpdated>(_onTodosUpdated);
  }

  void _onLoadTodos(LoadTodos event, Emitter<TodoState> emit) {
    emit(TodoLoading());
    _todosSubscription?.cancel();

    _todosSubscription = _todoRepository.getTodos().listen(
      (todos) {
        print("Received ${todos.length} todos from Firebase");
        add(_TodosUpdated(todos));
      },
      onError: (error) {
        print("Error loading todos: $error");
        emit(TodoError(error.toString()));
      },
    );
  }

  void _onTodosUpdated(_TodosUpdated event, Emitter<TodoState> emit) {
    final currentState = state;
    String searchQuery = '';

    if (currentState is TodoLoaded) {
      searchQuery = currentState.searchQuery;
    }

    final filteredTodos = _filterTodos(event.todos, searchQuery);
    emit(
      TodoLoaded(
        todos: event.todos,
        filteredTodos: filteredTodos,
        searchQuery: searchQuery,
      ),
    );
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      final now = DateTime.now();
      final todo = TodoModel(
        id: '',
        title: event.title,
        description: event.description,
        isDone: false,
        createdAt: now,
        updatedAt: now,
      );
      print("Adding todo: ${event.title}");
      await _todoRepository.addTodo(todo);
    } catch (e) {
      print("Error adding todo: $e");
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      print("Updating todo: ${event.todo.title}");
      await _todoRepository.updateTodo(event.todo);
    } catch (e) {
      print("Error updating todo: $e");
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      print("Deleting todo: ${event.todoId}");
      await _todoRepository.deleteTodo(event.todoId);
    } catch (e) {
      print("Error deleting todo: $e");
      emit(TodoError(e.toString()));
    }
  }

  Future<void> _onToggleTodoStatus(
    ToggleTodoStatus event,
    Emitter<TodoState> emit,
  ) async {
    try {
      print("Toggling todo status: ${event.todoId} -> ${event.isDone}");
      await _todoRepository.toggleTodoStatus(event.todoId, event.isDone);
    } catch (e) {
      print("Error toggling todo status: $e");
      emit(TodoError(e.toString()));
    }
  }

  void _onFilterTodos(FilterTodos event, Emitter<TodoState> emit) {
    if (state is TodoLoaded) {
      final currentState = state as TodoLoaded;
      final filteredTodos = _filterTodos(currentState.todos, event.query);
      emit(
        currentState.copyWith(
          filteredTodos: filteredTodos,
          searchQuery: event.query,
        ),
      );
    }
  }

  List<TodoModel> _filterTodos(List<TodoModel> todos, String query) {
    if (query.isEmpty) return todos;
    return todos
        .where(
          (todo) =>
              todo.title.toLowerCase().contains(query.toLowerCase()) ||
              todo.description.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<void> close() {
    _todosSubscription?.cancel();
    return super.close();
  }
}

class _TodosUpdated extends TodoEvent {
  final List<TodoModel> todos;

  const _TodosUpdated(this.todos);

  @override
  List<Object> get props => [todos];
}
