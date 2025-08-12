# Flutter App — CueZen Ball Detection

## Overview
Flutter client that:
- Lets the user pick a photo from the device
- Sends it to the Python server (`/detect`)
- Draws circles on detected balls with labels:
  - `cue`
  - `object (solid)`
  - `object (stripe)`

## Tech Stack
- Flutter (Dart)
- Clean architecture + BLoC
- Image picker + HTTP multipart upload
- CustomPainter overlay

## Prerequisites
- Flutter SDK installed and on PATH
- Android SDK (Android Studio or command-line tools)
- (macOS) Xcode for iOS builds (optional)
- A running instance of the **Python server** (see server README)

Check Flutter:
```bash
flutter --version
flutter doctor
```

## Project Structure (high level)
```
lib/
  core/
    network/
      api_client.dart
  data/
    datasources/
      detection_remote_data_source.dart
    models/
      detection_model.dart
    repositories/
      detection_repository_impl.dart
  domain/
    entities/
      detection.dart
    repositories/
      detection_repository.dart
    usecases/
      detect_balls_usecase.dart
  presentation/
    bloc/
      detection_event.dart
      detection_state.dart
      detection_bloc.dart
    pages/
      home_page.dart
    widgets/
      detection_painter.dart
main.dart
```

## Configure API Base URL
Open `lib/core/network/api_client.dart` and set your server URL:
```dart
const String kBaseUrl = "http://YOUR_LOCAL_IP:8000"; // or deployed URL
```
- If testing on an Android emulator, use `http://10.0.2.2:8000`.
- If testing on a real device, use your computer’s LAN IP.

## Run the App
```bash
flutter pub get
flutter run
```

## Build
### Android APK
```bash
flutter build apk --release
```

### iOS (archive)
Open the generated Xcode project under `ios/` and archive via Xcode.

## Usage
1) Launch the app.
2) Tap **Pick Image** and choose a pool table photo.
3) The app calls the server, receives detections, and overlays circles and labels.

## Customizing the Overlay
Edit `lib/presentation/widgets/detection_painter.dart`:
```dart
Color _ringColor(String label) {
  final l = label.toLowerCase();
  if (l == 'cue') return Colors.white;
  if (l.contains('stripe')) return Colors.blueAccent;
  return Colors.greenAccent;
}
```

## Troubleshooting
- **Nothing shows**: verify `kBaseUrl` is reachable from the device.
- **CORS**: already allowed on the server.
- **Gradle/JDK error**: use JDK 17 and AGP ≥ 8.2.1.

## Notes
- This is a classical CV approach (not YOLO). It performs well on clear shots but can miss balls under heavy shadows/occlusion.
- The **server** handles detection logic; improvements happen there.
