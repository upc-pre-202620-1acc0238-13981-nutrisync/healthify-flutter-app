import '../../../../core/common/error/result.dart';
import '../valueobject/preferred_language.dart';
import '../valueobject/user_id.dart';

/// The signed-in user's account.
abstract interface class UserRepository {
  /// `PUT /users/{userId}/preferred-language`. If the backend accepts it, the user stored on the device is updated
  /// too.
  Future<Result<void>> changePreferredLanguage(UserId userId, PreferredLanguage language);
}
