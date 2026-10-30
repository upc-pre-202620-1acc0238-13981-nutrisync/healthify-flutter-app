import '../../../../core/common/error/result.dart';
import '../../../../core/network/api_call.dart';
import '../../domain/repository/user_repository.dart';
import '../../domain/valueobject/preferred_language.dart';
import '../../domain/valueobject/user_id.dart';
import '../local/session_local_data_source.dart';
import '../remote/dto/session_dtos.dart';
import '../remote/session_service.dart';

class UserRepositoryImpl implements UserRepository {
  const UserRepositoryImpl(this._sessionService, this._localDataSource);

  final SessionService _sessionService;
  final SessionLocalDataSource _localDataSource;

  @override
  Future<Result<void>> changePreferredLanguage(UserId userId, PreferredLanguage language) async {
    final result = await apiCall<void>(() async {
      await _sessionService.changePreferredLanguage(
        userId.value,
        ChangePreferredLanguageRequestDto(language: language.code),
      );
    });
    if (result.isSuccess) await _localDataSource.updatePreferredLanguage(language);
    return result;
  }
}
