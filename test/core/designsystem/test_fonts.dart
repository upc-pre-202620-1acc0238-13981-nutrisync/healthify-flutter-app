import 'package:flutter/services.dart';

/// Loads the app's fonts so text measures like on a device. Widget tests draw every glyph as a wide square (Ahem) unless
/// the real fonts are loaded, which makes long labels overflow in tests only.
Future<void> loadAppFonts() async {
  Future<void> load(String family, List<String> files) async {
    final loader = FontLoader(family);
    for (final file in files) {
      loader.addFont(rootBundle.load(file));
    }
    await loader.load();
  }

  await load('OpenSans', [
    'assets/fonts/open_sans_regular.ttf',
    'assets/fonts/open_sans_semibold.ttf',
    'assets/fonts/open_sans_bold.ttf',
  ]);
  await load('Anton', ['assets/fonts/anton_regular.ttf']);
}
