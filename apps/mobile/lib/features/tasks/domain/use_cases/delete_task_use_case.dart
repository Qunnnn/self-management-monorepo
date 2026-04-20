import '../repositories/task_repository.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/network/index.dart';

class DeleteTaskUseCase {
  final TaskRepository _repository;

  DeleteTaskUseCase(this._repository);

  Future<Either<Failure, void>> execute(String id) async {
    return await _repository.deleteTask(id);
  }
}
