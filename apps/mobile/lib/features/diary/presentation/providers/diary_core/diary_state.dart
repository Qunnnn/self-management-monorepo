import 'package:mobile/core/import/app_imports.dart';

part 'diary_state.freezed.dart';

@freezed
abstract class DiaryState with _$DiaryState {
  const factory DiaryState({@Default([]) List<DiaryEntry> items}) = _DiaryState;

  const DiaryState._();
}
