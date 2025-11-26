# Flutter SDK Issue & Workaround

## Problem

The local Flutter SDK in `/frontend/flutter/` is a git clone and has corrupted/incomplete Dart compiler snapshots, preventing the application from running.

### Error

```
/Users/sagarchhetri/Downloads/Coding/Project/frontend/flutter/bin/cache/dart-sdk/bin/snapshots/frontend_server_aot.dart.snapshot is not an AOT snapshot, it cannot be run with 'dartaotruntime'
The Dart compiler exited unexpectedly.
```

## Root Cause

The Flutter directory appears to be a git clone of the Flutter repository rather than a properly built SDK. This means the Dart snapshots and cache artifacts are incomplete or not built correctly.

## Solutions

### Option 1: Install System-Wide Flutter (Recommended)

1. Download Flutter SDK from https://docs.flutter.dev/get-started/install/macos
2. Extract to a location like `~/development/flutter`
3. Add to PATH in `~/.zshrc`:
   ```bash
   export PATH="$PATH:$HOME/development/flutter/bin"
   ```
4. Run `flutter doctor` to verify installation
5. Navigate to `/frontend/` and run:
   ```bash
   flutter run -d chrome --web-port=8080
   ```

### Option 2: Build the Local Flutter SDK

If you must use the local Flutter SDK:

1. Navigate to the Flutter directory:
   ```bash
   cd /Users/sagarchhetri/Downloads/Coding/Project/frontend/flutter
   ```
2. Run the Flutter build:
   ```bash
   ./bin/flutter --version
   ./bin/flutter doctor
   ./bin/flutter precache --universal
   ```
3. This will build all necessary Dart snapshots and cache artifacts

### Option 3: Use Docker (For Consistent Builds)

Create a `Dockerfile` in the `/frontend/` directory:

```dockerfile
FROM cirrusci/flutter:stable

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get
COPY . .

EXPOSE 8080
CMD ["flutter", "run", "-d", "web-server", "--web-port=8080", "--web-hostname=0.0.0.0"]
```

## Current Status

- Desktop migration code: ✅ Complete
- Platform files: ✅ Generated (macOS, Windows, Linux)
- Dependencies: ✅ Installed
- **Application execution**: ❌ Blocked by SDK issue

## Next Steps

1. Install system-wide Flutter SDK (Option 1)
2. Test application launch
3. Validate desktop features (window management, adaptive navigation)
4. Build for distribution

## Notes

- The file_picker warnings are non-critical and can be ignored
- MaterialIcons font file was manually downloaded and is now present
- Chrome is available as a fallback platform for testing
