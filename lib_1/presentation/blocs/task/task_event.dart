import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class LoadTasksEvent extends TaskEvent {
  const LoadTasksEvent();
}

class LoadTasksByDateEvent extends TaskEvent {
  final DateTime date;
  const LoadTasksByDateEvent(this.date);
  @override
  List<Object?> get props => [date];
}

class CreateTaskEvent extends TaskEvent {
  final Task task;
  const CreateTaskEvent(this.task);
  @override
  List<Object?> get props => [task];
}

class UpdateTaskEvent extends TaskEvent {
  final Task task;
  const UpdateTaskEvent(this.task);
  @override
  List<Object?> get props => [task];
}

class DeleteTaskEvent extends TaskEvent {
  final String taskId;
  const DeleteTaskEvent(this.taskId);
  @override
  List<Object?> get props => [taskId];
}

class ToggleTaskCompleteEvent extends TaskEvent {
  final String taskId;
  final bool isCompleted;
  const ToggleTaskCompleteEvent(this.taskId, {required this.isCompleted});
  @override
  List<Object?> get props => [taskId, isCompleted];
}

class SearchTasksEvent extends TaskEvent {
  final String query;
  const SearchTasksEvent(this.query);
  @override
  List<Object?> get props => [query];
}
