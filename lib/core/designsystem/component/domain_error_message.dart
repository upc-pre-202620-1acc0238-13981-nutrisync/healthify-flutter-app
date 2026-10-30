import '../../common/error/domain_error.dart';
import '../../l10n/app_localizations.dart';

/// Generic text per error type. Use it only as a fallback: each screen first maps the codes
/// its "Notes" frame documents to its own mockup strings.
extension DomainErrorMessage on DomainError {
  String genericMessage(AppLocalizations l10n) => switch (this) {
    Network() => l10n.errorNetwork,
    Unauthorized() => l10n.errorUnauthorized,
    Forbidden() => l10n.errorForbidden,
    NotFound() => l10n.errorNotFound,
    Conflict() => l10n.errorConflict,
    Validation() => l10n.errorValidation,
    Unexpected() => l10n.errorUnexpected,
  };
}
