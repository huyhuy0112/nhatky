import 'package:flutter_bloc/flutter_bloc.dart';
import 'task_event.dart';
import 'task_state.dart';
import '../../../domain/entities/task.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  // TODO: inject usecases via constructor
  // final GetTasksUseCase _getTasksUseCase;
  // final CreateTaskUseCase _createTaskUseCase;
  // ...

  TaskBloc() : super(TaskInitial()) {
    on<LoadTasksEvent>(_onLoadTasks);
    on<LoadTasksByDateEvent>(_onLoadTasksByDate);
    on<CreateTaskEvent>(_onCreateTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskCompleteEvent>(_onToggleComplete);
    on<SearchTasksEvent>(_onSearchTasks);
  }

  final List<Task> _allTasks = []; // Will be replaced by repository

  Future<void> _onLoadTasks(LoadTasksEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      // TODO: replace with usecase call
      // final tasks = await _getTasksUseCase();
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final tomorrow = today.add(const Duration(days: 1));
      final nextWeek = today.add(const Duration(days: 7));

      final todayTasks = _allTasks.where((t) {
        if (t.deadline == null) return false;
        final d = DateTime(t.deadline!.year, t.deadline!.month, t.deadline!.day);
        return d == today && !t.isCompleted;
      }).toList();

      final overdueTasks = _allTasks.where((t) =>
        t.deadline != null && t.deadline!.isBefore(now) && !t.isCompleted
      ).toList();

      final upcomingTasks = _allTasks.where((t) {
        if (t.deadline == null || t.isCompleted) return false;
        return t.deadline!.isAfter(now) && t.deadline!.isBefore(nextWeek);
      }).toList();

      final completedTasks = _allTasks.where((t) => t.isCompleted).toList();

      emit(TaskLoaded(
        tasks: _allTasks,
        todayTasks: todayTasks,
        overdueTasks: overdueTasks,
        upcomingTasks: upcomingTasks,
        completedTasks: completedTasks,
      ));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onLoadTasksByDate(LoadTasksByDateEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading());
    try {
      final day = DateTime(event.date.year, event.date.month, event.date.day);
      final filtered = _allTasks.where((t) {
        if (t.deadline == null) return false;
        final d = DateTime(t.deadline!.year, t.deadline!.month, t.deadline!.day);
        return d == day;
      }).toList();

      emit(TaskLoaded(
        tasks: filtered,
        todayTasks: filtered,
        overdueTasks: [],
        upcomingTasks: [],
        completedTasks: filtered.where((t) => t.isCompleted).toList(),
      ));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onCreateTask(CreateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      _allTasks.add(event.task);
      add(const LoadTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    try {
      final index = _allTasks.indexWhere((t) => t.id == event.task.id);
      if (index != -1) _allTasks[index] = event.task;
      add(const LoadTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    try {
      _allTasks.removeWhere((t) => t.id == event.taskId);
      add(const LoadTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onToggleComplete(ToggleTaskCompleteEvent event, Emitter<TaskState> emit) async {
    try {
      final index = _allTasks.indexWhere((t) => t.id == event.taskId);
      if (index != -1) {
        _allTasks[index] = _allTasks[index].copyWith(
          status: event.isCompleted ? TaskStatus.completed : TaskStatus.active,
          updatedAt: DateTime.now(),
        );
      }
      add(const LoadTasksEvent());
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  Future<void> _onSearchTasks(SearchTasksEvent event, Emitter<TaskState> emit) async {
    try {
      final q = event.query.toLowerCase();
      final results = _allTasks.where((t) =>
        t.title.toLowerCase().contains(q) ||
        (t.note?.toLowerCase().contains(q) ?? false) ||
        t.tags.any((tag) => tag.toLowerCase().contains(q))
      ).toList();

      emit(TaskLoaded(
        tasks: results,
        todayTasks: results,
        overdueTasks: [],
        upcomingTasks: [],
        completedTasks: results.where((t) => t.isCompleted).toList(),
      ));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
