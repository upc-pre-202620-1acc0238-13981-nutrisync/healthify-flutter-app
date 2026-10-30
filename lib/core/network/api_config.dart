/// Backend root, overridable at build time: `--dart-define=BASE_URL=https://host/api/v1/`.
const String _baseUrl = String.fromEnvironment(
  'BASE_URL',
  defaultValue: 'https://platform.healthify.lat/api/v1/',
);

/// [_baseUrl] with a trailing slash, so relative paths resolve under `/api/v1/` instead of replacing `v1`.
final Uri apiBaseUrl = Uri.parse(_baseUrl.endsWith('/') ? _baseUrl : '$_baseUrl/');

// Generous: the backend AI features have a 20 s timeout + one retry.
const Duration connectTimeout = Duration(seconds: 30);
const Duration defaultReadTimeout = Duration(seconds: 60);
