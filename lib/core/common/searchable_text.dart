// Accented Latin letters and the plain letter that matches them in a search (what NFD + dropping combining marks gives).
const _accentFolds = {
  'a': 'àáâãäåāăą',
  'c': 'çćĉċč',
  'd': 'ďđ',
  'e': 'èéêëēĕėęě',
  'g': 'ĝğġģ',
  'h': 'ĥħ',
  'i': 'ìíîïĩīĭįı',
  'j': 'ĵ',
  'k': 'ķ',
  'l': 'ĺļľŀł',
  'n': 'ñńņňŉ',
  'o': 'òóôõöøōŏő',
  'r': 'ŕŗř',
  's': 'śŝşš',
  't': 'ţťŧ',
  'u': 'ùúûüũūŭůűų',
  'w': 'ŵ',
  'y': 'ýÿŷ',
  'z': 'źżž',
};

final _foldTable = <int, String>{
  for (final entry in _accentFolds.entries)
    for (final rune in entry.value.runes) rune: entry.key,
};

/// "Ramírez" is found by typing "ramirez": the text trimmed, lowercase and without accents, for case- and
/// accent-insensitive searches done on the phone.
extension SearchableText on String {
  String get searchable {
    final buffer = StringBuffer();
    for (final rune in trim().toLowerCase().runes) {
      buffer.write(_foldTable[rune] ?? String.fromCharCode(rune));
    }
    return buffer.toString();
  }
}
