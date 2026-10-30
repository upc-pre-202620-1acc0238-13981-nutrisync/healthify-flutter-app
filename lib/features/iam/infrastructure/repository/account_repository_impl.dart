import '../../../../core/common/error/result.dart';
import '../../../../core/network/api_call.dart';
import '../../domain/repository/account_repository.dart';
import '../../domain/valueobject/user_id.dart';
import '../local/session_local_data_source.dart';
import '../remote/session_service.dart';

class AccountRepositoryImpl implements AccountRepository {
  const AccountRepositoryImpl(this._sessionService, this._localDataSource);

  final SessionService _sessionService;
  final SessionLocalDataSource _localDataSource;

  @override
  Future<Result<DateTime>> getCreatedOn(UserId userId) async {
    final stored = DateTime.tryParse(_localDataSource.accountCreatedAt(userId.value) ?? '');
    if (stored != null) return Result.success(_toLocalDay(stored));

    final result = await apiCall(() async {
      final createdAt = (await _sessionService.getUser(userId.value)).createdAt;
      return (raw: createdAt, instant: DateTime.parse(createdAt ?? ''));
    });
    final read = result.valueOrNull;
    if (read == null) return Result.failure(result.errorOrNull!);
    await _localDataSource.saveAccountCreatedAt(userId.value, read.raw!);
    return Result.success(_toLocalDay(read.instant));
  }

  DateTime _toLocalDay(DateTime instant) {
    final local = instant.toLocal();
    return DateTime(local.year, local.month, local.day);
  }
}
