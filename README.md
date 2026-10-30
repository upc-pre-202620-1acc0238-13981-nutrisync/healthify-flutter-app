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

## CI/CD

| Workflow | When | What it does |
|---|---|---|
| `ci.yml` | Pull requests to `develop` or `main`, pushes to `develop` | Generators, `flutter analyze`, `flutter test --coverage` and `flutter build apk --debug`. Uploads `coverage/lcov.info` as the `reports` artifact |
| `distribute.yml` | Pushes to `main`, or by hand from the Actions tab | Builds the signed release APK, uploads it to Firebase App Distribution (group `qa`) and creates the GitHub release |

`distribute.yml` in detail:

- The version comes from `version` in `pubspec.yaml`, without the `+build` part (`0.1.0+1` → tag `v0.1.0`).
  A push to `main` with an already released version fails: bump `version` in `pubspec.yaml`. A manual run of an
  already released version only redistributes it, without a new GitHub release.
- Each distributed build takes the workflow run number as its build number (`versionCode`).
- Release notes for testers are the last 10 commits, without merges.
- The APK is also kept as the `healthify-release-<run number>` artifact, and attached to the GitHub release as
  `healthify-v<version>.apk`.

### Repository secrets

| Secret | Value |
|---|---|
| `FIREBASE_APP_ID` | Firebase App ID of the Android app `pe.edu.upc.healthify.practitioner` |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | JSON key of a service account with the *Firebase App Distribution Admin* role |
| `KEYSTORE_BASE64` | Upload keystore (`.jks`) encoded in base64 |
| `KEYSTORE_PASSWORD` | Keystore password |
| `KEY_ALIAS` | Key alias |
| `KEY_PASSWORD` | Key password |

The app uses no Firebase SDK: there is no `google-services.json`, only the Firebase CLI uploads the APK.
