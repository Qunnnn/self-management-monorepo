import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/todo_task.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const TaskModel._(); // Added private constructor to allow methods

  const factory TaskModel({
    required String id,
    required String userId,
    required String title,
    String? description,
    required bool isCompleted,
    required DateTime createdAt,
    DateTime? deletedAt,
  }) = _TaskModel;

  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);

  factory TaskModel.fromEntity(TodoTask entity) => TaskModel(
        id: entity.id,
        userId: entity.userId,
        title: entity.title,
        description: entity.description,
        isCompleted: entity.isCompleted,
        createdAt: entity.createdAt,
        deletedAt: entity.deletedAt,
      );

  TodoTask toEntity() => TodoTask(
        id: id,
        userId: userId,
        title: title,
        description: description,
        isCompleted: isCompleted,
        createdAt: createdAt,
        deletedAt: deletedAt,
      );
}
