import 'dart:convert';

import '../common/error/domain_error.dart';

/// Translates a backend error response (RFC 7807, `application/problem+json`) into a [DomainError].
///
/// Every ProblemDetails carries `extensions.code` with the name of the error enum value (`InvalidCredentials`,
/// `AccountLocked`, `AuthenticationRequired`...). ASP.NET serializes `Extensions` flattened, so it arrives as a
/// top-level `code`; it is also accepted inside `extensions` just in case. The UI decides by that code, never by
/// `title`/`detail` (already localized).
///
/// Empty framework responses (`Forbid()`, role 403, route 404, 405, 415) carry no `code`: the error
/// has no code, or `HTTP_<status>` in [Validation]/[Unexpected].
abstract final class ProblemDetailsMapper {
  static const _codeKey = 'code';
  static const _extensionsKey = 'extensions';

  static DomainError map(int status, String? body) {
    final code = body == null ? null : _extractCode(body);
    return switch (status) {
      401 => Unauthorized(code),
      403 => Forbidden(code),
      404 => NotFound(code),
      409 => Conflict(code),
      400 || 413 || 415 || 422 => Validation(code ?? 'HTTP_$status'),
      _ => Unexpected(code ?? 'HTTP_$status'),
    };
  }

  static String? _extractCode(String body) {
    if (body.trim().isEmpty) return null;
    final Object? root;
    try {
      root = jsonDecode(body);
    } on FormatException {
      return null;
    }
    if (root is! Map<String, dynamic>) return null;
    final extensions = root[_extensionsKey];
    return _codeField(root) ?? (extensions is Map<String, dynamic> ? _codeField(extensions) : null);
  }

  static String? _codeField(Map<String, dynamic> json) {
    final value = json[_codeKey];
    return value is String && value.trim().isNotEmpty ? value : null;
  }
}
