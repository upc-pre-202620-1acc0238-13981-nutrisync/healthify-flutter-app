# healthify

Healthify for nutritionists (practitioner role), in Flutter. Port of the practitioner view of the native Android app;
the patient role is not ported. Application ID: `pe.edu.upc.healthify.practitioner`. Only Android is distributed.

## Running the app

Requires Flutter 3.47.7 (stable).

```sh
flutter pub get
dart run build_runner build -d   # json_serializable DTOs and freezed states (*.g.dart, *.freezed.dart)
flutter gen-l10n                 # AppLocalizations from lib/core/l10n/app_es.arb (base) and app_en.arb
flutter run
```

The backend defaults to `https://platform.healthify.lat/api/v1/`. Point it elsewhere with `--dart-define`:

```sh
flutter run --dart-define=BASE_URL=http://10.0.2.2:<port>/api/v1/
```

(`10.0.2.2` is the host machine as seen from the Android emulator.)

Run the generators again after changing a DTO, a `freezed` state or an ARB file. Generated files are not edited by hand.

## Checks

```sh
flutter analyze
flutter test              # add --coverage to write coverage/lcov.info
```
