/// What was typed in "Search food", without extra spaces.
///
/// Search starts at 2 characters; the server only adds external providers from 3, so with 2 the answer comes from the
/// server's local catalog.
extension type const FoodSearchTerm._(String value) {
  static const minLength = 2;
  static const maxLength = 80;

  /// `null` if too short to search: the catalog is then listed unfiltered.
  static FoodSearchTerm? of(String raw) {
    final trimmed = raw.trim().replaceAll(_whitespace, ' ');
    if (trimmed.length < minLength) return null;
    return FoodSearchTerm._(trimmed.length > maxLength ? trimmed.substring(0, maxLength) : trimmed);
  }
}

final _whitespace = RegExp(r'\s+');
