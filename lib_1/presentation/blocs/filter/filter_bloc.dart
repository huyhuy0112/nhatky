import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/task.dart';

// ─── Events ───────────────────────────────────────────────
abstract class FilterEvent extends Equatable {
  const FilterEvent();
  @override List<Object?> get props => [];
}

class SetStatusFilterEvent extends FilterEvent {
  final String status; // 'all' | 'active' | 'completed'
  const SetStatusFilterEvent(this.status);
  @override List<Object?> get props => [status];
}

class SetPriorityFilterEvent extends FilterEvent {
  final Priority? priority;
  const SetPriorityFilterEvent(this.priority);
  @override List<Object?> get props => [priority];
}

class SetCategoryFilterEvent extends FilterEvent {
  final String? categoryId;
  const SetCategoryFilterEvent(this.categoryId);
  @override List<Object?> get props => [categoryId];
}

class SetSortEvent extends FilterEvent {
  final String sort; // 'deadline' | 'priority' | 'created' | 'name'
  const SetSortEvent(this.sort);
  @override List<Object?> get props => [sort];
}

class ResetFilterEvent extends FilterEvent {}

// ─── State ────────────────────────────────────────────────
class FilterState extends Equatable {
  final String status;
  final Priority? priority;
  final String? categoryId;
  final String sort;

  const FilterState({
    this.status = 'all',
    this.priority,
    this.categoryId,
    this.sort = 'deadline',
  });

  bool get hasActiveFilters =>
    status != 'all' || priority != null || categoryId != null || sort != 'deadline';

  FilterState copyWith({
    String? status,
    Priority? priority,
    String? categoryId,
    String? sort,
    bool clearPriority = false,
    bool clearCategory = false,
  }) {
    return FilterState(
      status: status ?? this.status,
      priority: clearPriority ? null : priority ?? this.priority,
      categoryId: clearCategory ? null : categoryId ?? this.categoryId,
      sort: sort ?? this.sort,
    );
  }

  @override
  List<Object?> get props => [status, priority, categoryId, sort];
}

// ─── Bloc ─────────────────────────────────────────────────
class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(const FilterState()) {
    on<SetStatusFilterEvent>(_onSetStatusFilter);
    on<SetPriorityFilterEvent>(_onSetPriorityFilter);
    on<SetCategoryFilterEvent>(_onSetCategoryFilter);
    on<SetSortEvent>(_onSetSort);
    on<ResetFilterEvent>(_onResetFilter);
  }

  Future<void> _onSetStatusFilter(
    SetStatusFilterEvent event,
    Emitter<FilterState> emit,
  ) async {
    emit(state.copyWith(status: event.status));
  }

  Future<void> _onSetPriorityFilter(
    SetPriorityFilterEvent event,
    Emitter<FilterState> emit,
  ) async {
    emit(state.copyWith(
      priority: event.priority,
      clearPriority: event.priority == null,
    ));
  }

  Future<void> _onSetCategoryFilter(
    SetCategoryFilterEvent event,
    Emitter<FilterState> emit,
  ) async {
    emit(state.copyWith(
      categoryId: event.categoryId,
      clearCategory: event.categoryId == null,
    ));
  }

  Future<void> _onSetSort(
    SetSortEvent event,
    Emitter<FilterState> emit,
  ) async {
    emit(state.copyWith(sort: event.sort));
  }

  Future<void> _onResetFilter(
    ResetFilterEvent event,
    Emitter<FilterState> emit,
  ) async {
    emit(const FilterState());
  }
}
