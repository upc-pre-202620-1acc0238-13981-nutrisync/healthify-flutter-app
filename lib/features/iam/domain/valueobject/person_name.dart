/// Why a name part does not work for a new account.
enum PersonNameProblem { required, invalidCharacters, tooLong }

/// Given and family names. Family names may be empty: accounts created before names were required kept the local part
/// of the email as the given name and no family names. A new account is validated with [PersonName.forSignUp], which
/// also applies the rules of the backend `PersonName` VO.
final class PersonName {
  /// Throws [ArgumentError] if the parts are not trimmed, [givenNames] is blank or a part is too long.
  PersonName(this.givenNames, this.familyNames) {
    if (givenNames.trim().isEmpty) throw ArgumentError.value(givenNames, 'givenNames', 'Given names are required');
    if (givenNames != givenNames.trim() || familyNames != familyNames.trim()) {
      throw ArgumentError('Names must be trimmed');
    }
    if (givenNames.length > maxLength || familyNames.length > maxLength) throw ArgumentError('Name too long');
  }

  factory PersonName.of(String givenNames, String familyNames) =>
      PersonName(givenNames.trim(), familyNames.trim());

  /// Name of a new account, with the backend rules: both parts required, inner spaces collapsed, up to 80
  /// characters and no digits or `<` `>`.
  ///
  /// Throws [ArgumentError] if a part does not meet them ([problemOf] says why).
  factory PersonName.forSignUp(String givenNames, String familyNames) {
    if (problemOf(givenNames) != null || problemOf(familyNames) != null) throw ArgumentError('Invalid name');
    return PersonName(_normalize(givenNames), _normalize(familyNames));
  }

  static const maxLength = 80;

  static final _innerWhitespace = RegExp(r'\s+');
  static final _forbidden = RegExp(r'[0-9<>]');

  final String givenNames;
  final String familyNames;

  /// «María José» → «María», for «Hola, María».
  String get firstGivenName => givenNames.split(' ').first;

  String get fullName => familyNames.isEmpty ? givenNames : '$givenNames $familyNames';

  /// Avatar initial.
  String get initial => givenNames.substring(0, 1).toUpperCase();

  /// The problem with a name part of a new account, or `null` if it is fine.
  static PersonNameProblem? problemOf(String part) {
    final normalized = _normalize(part);
    if (normalized.isEmpty) return PersonNameProblem.required;
    if (normalized.length > maxLength) return PersonNameProblem.tooLong;
    if (_forbidden.hasMatch(normalized)) return PersonNameProblem.invalidCharacters;
    return null;
  }

  static String _normalize(String part) => part.trim().replaceAll(_innerWhitespace, ' ');

  @override
  bool operator ==(Object other) =>
      other is PersonName && other.givenNames == givenNames && other.familyNames == familyNames;

  @override
  int get hashCode => Object.hash(givenNames, familyNames);

  @override
  String toString() => 'PersonName($fullName)';
}
