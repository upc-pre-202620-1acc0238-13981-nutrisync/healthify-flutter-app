import 'package:http/http.dart' as http;

import 'app_language_provider.dart';

/// Sends the current app language in `Accept-Language` on every request. The backend localizes ProblemDetails
/// and generates AI texts in that language (es/en).
class AcceptLanguageClient extends http.BaseClient {
  AcceptLanguageClient(this._inner, this._languageProvider);

  final http.Client _inner;
  final AppLanguageProvider _languageProvider;

  static const header = 'Accept-Language';

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers[header] = _languageProvider.currentLanguage();
    return _inner.send(request);
  }

  @override
  void close() => _inner.close();
}
