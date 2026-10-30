import 'package:freezed_annotation/freezed_annotation.dart';

part 'welcome_state.freezed.dart';

/// [showOfflineBanner]: "Offline: top banner on tapping a button"; hidden when the connection returns.
@freezed
abstract class WelcomeState with _$WelcomeState {
  const factory WelcomeState({@Default(false) bool showOfflineBanner}) = _WelcomeState;
}

sealed class WelcomeEvent {
  const WelcomeEvent();
}

final class WelcomeNavigateToSignUp extends WelcomeEvent {
  const WelcomeNavigateToSignUp();
}

final class WelcomeNavigateToSignIn extends WelcomeEvent {
  const WelcomeNavigateToSignIn();
}
