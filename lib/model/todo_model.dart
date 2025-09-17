// lib/models/todo_model.dart
import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isDone;
  final DateTime createdAt;
  final DateTime updatedAt;

  const TodoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TodoModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TodoModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isDone: data['isDone'] ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isDone': isDone,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isDone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    isDone,
    createdAt,
    updatedAt,
  ];
}
