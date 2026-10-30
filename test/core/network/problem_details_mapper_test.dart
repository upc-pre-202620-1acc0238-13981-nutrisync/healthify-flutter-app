import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/core/common/error/domain_error.dart';
import 'package:healthify/core/network/problem_details_mapper.dart';

void main() {
  String problem(int status, String code) =>
      '{"type":"about:blank","title":"Título localizado","status":$status,"detail":"Detalle","code":"$code"}';

  test('reads the top level code that the backend sends', () {
    expect(ProblemDetailsMapper.map(401, problem(401, 'InvalidCredentials')), const Unauthorized('InvalidCredentials'));
    expect(ProblemDetailsMapper.map(401, problem(401, 'AccountLocked')), const Unauthorized('AccountLocked'));
    expect(ProblemDetailsMapper.map(403, problem(403, 'AiConsentRequired')), const Forbidden('AiConsentRequired'));
    expect(ProblemDetailsMapper.map(404, problem(404, 'CareLinkNotFound')), const NotFound('CareLinkNotFound'));
    expect(ProblemDetailsMapper.map(409, problem(409, 'EmailAlreadyTaken')), const Conflict('EmailAlreadyTaken'));
    expect(ProblemDetailsMapper.map(400, problem(400, 'WeakPassword')), const Validation('WeakPassword'));
    expect(ProblemDetailsMapper.map(413, problem(413, 'PhotoTooLarge')), const Validation('PhotoTooLarge'));
    expect(ProblemDetailsMapper.map(429, problem(429, 'AiQuotaExceeded')), const Unexpected('AiQuotaExceeded'));
    expect(ProblemDetailsMapper.map(500, problem(500, 'InternalError')), const Unexpected('InternalError'));
    expect(
      ProblemDetailsMapper.map(503, problem(503, 'AiProviderUnavailable')),
      const Unexpected('AiProviderUnavailable'),
    );
  });

  test('distinguishes two 401s only by code', () {
    final invalid = ProblemDetailsMapper.map(401, problem(401, 'InvalidCredentials'));
    final locked = ProblemDetailsMapper.map(401, problem(401, 'AccountLocked'));

    expect((invalid as Unauthorized).code, 'InvalidCredentials');
    expect((locked as Unauthorized).code, 'AccountLocked');
  });

  test('validation problem keeps its code and ignores the errors map', () {
    const body = '{"status":400,"title":"x","errors":{"Email":["required"]},"code":"ValidationFailed"}';

    expect(ProblemDetailsMapper.map(400, body), const Validation('ValidationFailed'));
  });

  test('extra extensions do not interfere', () {
    const body = '{"status":409,"code":"ConsultationAlreadyOpen","consultationId":42}';

    expect(ProblemDetailsMapper.map(409, body), const Conflict('ConsultationAlreadyOpen'));
  });

  test('reads code nested in extensions as a fallback', () {
    const body = '{"status":401,"extensions":{"code":"AccountLocked"}}';

    expect(ProblemDetailsMapper.map(401, body), const Unauthorized('AccountLocked'));
  });

  test('empty framework responses decide by status', () {
    expect(ProblemDetailsMapper.map(403, ''), const Forbidden());
    expect(ProblemDetailsMapper.map(404, null), const NotFound());
    expect(ProblemDetailsMapper.map(405, ''), const Unexpected('HTTP_405'));
    expect(ProblemDetailsMapper.map(415, ''), const Validation('HTTP_415'));
  });

  test('malformed body or non string code does not crash', () {
    expect(ProblemDetailsMapper.map(400, '<html>'), const Validation('HTTP_400'));
    expect(ProblemDetailsMapper.map(422, '{"code":12}'), const Validation('HTTP_422'));
    expect(ProblemDetailsMapper.map(409, '{"code":"  "}'), const Conflict());
    expect(ProblemDetailsMapper.map(500, '[]'), const Unexpected('HTTP_500'));
  });
}
