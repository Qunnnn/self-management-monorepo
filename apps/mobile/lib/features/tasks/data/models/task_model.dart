import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/todo_task.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel {
  final String id;
  final String userId;
  final String title;
  final String? description;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime? deletedAt;

  const TaskModel({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.isCompleted,
    required this.createdAt,
    this.deletedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);
  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

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
