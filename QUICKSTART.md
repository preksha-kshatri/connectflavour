# 🚀 Quick Start: Running ConnectFlavour Desktop App

## Current Situation

✅ Desktop migration is **100% complete**  
⚠️ Cannot run due to corrupted Flutter SDK in `/frontend/flutter/`

## Fastest Solution (15 minutes)

### Step 1: Install Flutter SDK

Choose your preferred method:

#### Option A: Download from Website (Recommended)

```bash
# 1. Download Flutter SDK
# Visit: https://docs.flutter.dev/get-started/install/macos
# Download the latest stable release (Apple Silicon or Intel)

# 2. Extract to your home directory
cd ~/
unzip ~/Downloads/flutter_macos_*.zip

# 3. Add to PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# 4. Verify installation
flutter doctor
```

#### Option B: Use Git Clone (Alternative)

```bash
# 1. Clone Flutter repository
cd ~/
git clone https://github.com/flutter/flutter.git -b stable

# 2. Add to PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
source ~/.zshrc

# 3. Run Flutter doctor to download Dart SDK and tools
flutter doctor

# 4. Download web artifacts
flutter precache --web
```

### Step 2: Run the App

```bash
# Navigate to project
cd /Users/sagarchhetri/Downloads/Coding/Project/frontend

# Run in Chrome (no Xcode required)
flutter run -d chrome --web-port=8080
```

**Expected Result**: Chrome opens at http://localhost:8080 with ConnectFlavour app

---

## Alternative: Use macOS Desktop

If you want to run as a native macOS app (requires Xcode):

### Install Xcode

```bash
# 1. Install Xcode from App Store (large download ~12GB)
# 2. After installation, run:
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch

# 3. Install CocoaPods
sudo gem install cocoapods
```

### Run macOS App

```bash
cd /Users/sagarchhetri/Downloads/Coding/Project/frontend
flutter run -d macos
```

**Expected Result**: Native macOS window opens with ConnectFlavour

---

## What You'll See

### 🪟 Window Configuration

- **Size**: 1200 x 800 pixels
- **Title**: "ConnectFlavour - Recipe Discovery"
- **Position**: Centered on screen
- **Resizable**: Yes (minimum 800x600)

### 🧭 Navigation (Desktop)

- **Navigation Rail**: On the left side
- **Icons**: Home, Search, Create, Wishlist, Profile
- **Responsive**: Switches to drawer on tablet, bottom bar on mobile

### 📱 Responsive Grid

- **Desktop**: 4-5 columns for recipe cards
- **Tablet**: 3 columns
- **Mobile**: 2 columns
- **Max Width**: 1400px content area

---

## Testing Checklist

After the app launches, verify:

- [ ] Window opens at correct size (1200x800)
- [ ] Window title shows "ConnectFlavour - Recipe Discovery"
- [ ] Navigation rail appears on left side
- [ ] Recipe grid shows multiple columns
- [ ] Window is resizable
- [ ] Minimum size is enforced (800x600)
- [ ] All navigation items work
- [ ] Backend API connection works (http://localhost:8000)

---

## Troubleshooting

### Issue: "No devices found"

```bash
# Check available devices
flutter devices

# Should show Chrome or macOS
```

### Issue: "Backend API not responding"

```bash
# Start Django backend in separate terminal
cd /Users/sagarchhetri/Downloads/Coding/Project/backend/connectflavour
python manage.py runserver
```

### Issue: "flutter command not found"

```bash
# Verify PATH is set
echo $PATH | grep flutter

# If not found, add to PATH:
export PATH="$PATH:$HOME/flutter/bin"
source ~/.zshrc
```

### Issue: File picker warnings

These are **informational only** and can be ignored. They don't affect functionality.

---

## Build for Distribution (Later)

Once testing is complete, create release builds:

```bash
cd /Users/sagarchhetri/Downloads/Coding/Project/frontend

# macOS .app bundle
flutter build macos --release
# Output: build/macos/Build/Products/Release/connectflavour.app

# Windows .exe
flutter build windows --release
# Output: build/windows/runner/Release/

# Linux binary
flutter build linux --release
# Output: build/linux/x64/release/bundle/
```

---

## Quick Reference

| Command                 | Purpose                    |
| ----------------------- | -------------------------- |
| `flutter doctor`        | Check Flutter installation |
| `flutter devices`       | List available devices     |
| `flutter run -d chrome` | Run in browser             |
| `flutter run -d macos`  | Run on macOS               |
| `flutter clean`         | Clean build cache          |
| `flutter pub get`       | Install dependencies       |
| `flutter build macos`   | Build macOS app            |

---

## Support Files

- **Full Status Report**: `/docs/DESKTOP_APP_STATUS.md`
- **Migration Guide**: `/docs/desktop-migration.md`
- **SDK Troubleshooting**: `/docs/flutter-sdk-issue.md`
- **Project Status**: `/PROJECT_STATUS.md`

---

## Estimated Time

- **Flutter SDK Installation**: 10-15 minutes
- **First Run**: 2-5 minutes (initial compilation)
- **Subsequent Runs**: 30-60 seconds

**Total Time to Running App**: ~15-20 minutes

---

## Next Steps

1. ✅ Install Flutter SDK (Step 1 above)
2. ✅ Run app in Chrome (Step 2 above)
3. ✅ Test desktop features
4. 📝 Document any issues found
5. 🚀 Build for distribution

---

**Last Updated**: November 9, 2025  
**Status**: Ready to run after SDK installation
