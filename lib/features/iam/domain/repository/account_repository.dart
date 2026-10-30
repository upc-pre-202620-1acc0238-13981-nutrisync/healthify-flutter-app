import '../../../../core/common/error/result.dart';
import '../valueobject/user_id.dart';

/// Data about the signed-in user's account that does not come with sign-in.
abstract interface class AccountRepository {
  /// Day (in the phone's time zone, as a date-only `DateTime`) the account was created: `GET /users/{userId}` ->
  /// `createdAt`. Read once and stored with the session; offline and with no previous read it fails with `Network`.
  Future<Result<DateTime>> getCreatedOn(UserId userId);
}
