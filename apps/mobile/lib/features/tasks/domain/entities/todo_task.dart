import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_task.freezed.dart';

@freezed
class TodoTask with _$TodoTask {
  const factory TodoTask({
    required String id,
    required String userId,
    required String title,
    String? description,
    @Default(false) bool isCompleted,
    required DateTime createdAt,
    DateTime? deletedAt,
  }) = _TodoTask;
}
