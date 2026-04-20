import 'package:freezed_annotation/freezed_annotation.dart';

part 'todo_task.freezed.dart';
part 'todo_task.g.dart';

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

  factory TodoTask.fromJson(Map<String, dynamic> json) => _$TodoTaskFromJson(json);
}
