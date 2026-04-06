import 'package:equatable/equatable.dart';

enum Priority { high, medium, low, none }
enum TaskStatus { active, completed }

class Task extends Equatable {
  final String id;
  final String title;
  final String? note;
  final DateTime? deadline;
  final DateTime? reminderAt;
  final Priority priority;
  final TaskStatus status;
  final String? categoryId;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Task({
    required this.id,
    required this.title,
    this.note,
    this.deadline,
    this.reminderAt,
    this.priority = Priority.none,
    this.status = TaskStatus.active,
    this.categoryId,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isOverdue => deadline != null &&
      status == TaskStatus.active &&
      deadline!.isBefore(DateTime.now());

  bool get isCompleted => status == TaskStatus.completed;

  Task copyWith({
    String? id,
    String? title,
    String? note,
    DateTime? deadline,
    DateTime? reminderAt,
    Priority? priority,
    TaskStatus? status,
    String? categoryId,
    List<String>? tags,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      note: note ?? this.note,
      deadline: deadline ?? this.deadline,
      reminderAt: reminderAt ?? this.reminderAt,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      categoryId: categoryId ?? this.categoryId,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, note, deadline, priority, status, categoryId, tags, createdAt];
}
