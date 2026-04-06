import 'package:equatable/equatable.dart';
import '../../../domain/entities/task.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object?> get props => [];
}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final List<Task> todayTasks;
  final List<Task> overdueTasks;
  final List<Task> upcomingTasks;
  final List<Task> completedTasks;

  const TaskLoaded({
    required this.tasks,
    required this.todayTasks,
    required this.overdueTasks,
    required this.upcomingTasks,
    required this.completedTasks,
  });

  @override
  List<Object?> get props => [tasks, todayTasks, overdueTasks, upcomingTasks, completedTasks];
}

class TaskOperationSuccess extends TaskState {
  final String message;
  const TaskOperationSuccess(this.message);
}

class TaskError extends TaskState {
  final String message;
  const TaskError(this.message);
  @override
  List<Object?> get props => [message];
}
