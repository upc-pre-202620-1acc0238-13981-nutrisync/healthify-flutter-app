import 'package:flutter_test/flutter_test.dart';
import 'package:healthify/features/carerelationship/domain/valueobject/invitation_token.dart';

/// The token's shape, and its «blocks of four» display for the nutritionist to read out.
void main() {
  const valid = 'q3Zl0_8xYb-Tn4Wc2Vd9Rk7Hs1Jm6Pa5Ue0Fi3Gt4Lo';

  group('grouped', () {
    test('writes blocks of four separated by a space', () {
      final token = InvitationToken('kP3x9Qm2LrT7vB8nZc4WdA');

      expect(token.grouped(), 'kP3x 9Qm2 LrT7 vB8n Zc4W dA');
    });

    test('a length that is a multiple of four has no trailing space or short block', () {
      final token = InvitationToken('a' * 24);

      expect(token.grouped(), 'aaaa aaaa aaaa aaaa aaaa aaaa');
    });

    test('the groups type back to the same token', () {
      final token = InvitationToken(valid);

      expect(token.grouped().replaceAll(' ', ''), valid);
      expect(InvitationToken.parse(token.grouped().replaceAll(' ', '')), token);
    });

    test('keeps the exact case and the url-safe symbols', () {
      final token = InvitationToken('Ab-_CdEfGhIjKlMnOpQrSt');

      expect(token.grouped(), 'Ab-_ CdEf GhIj KlMn OpQr St');
    });

    test('the longest token has 16 blocks', () {
      final token = InvitationToken('z' * InvitationToken.maxLength);

      expect(token.grouped().split(' '), hasLength(16));
    });
  });

  group('shape (unchanged)', () {
    test('a token has 22 to 64 url-safe characters', () {
      expect(InvitationToken.parse('a' * 22), isNotNull);
      expect(InvitationToken.parse('a' * 64), isNotNull);
      expect(InvitationToken.parse('a' * 21), isNull);
      expect(InvitationToken.parse('a' * 65), isNull);
      expect(InvitationToken.parse('${'a' * 21}!'), isNull);
    });

    test('toString never prints the secret', () {
      final token = InvitationToken(valid);

      expect('$token', isNot(contains(valid.substring(0, 8))));
      expect('$token', 'InvitationToken(***)');
    });
  });
}
