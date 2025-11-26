# 🚀 Flutter Installation Guide for ConnectFlavour

You mentioned Flutter is installed, but it's not in your system PATH. Here's how to properly set it up:

## 🎯 **Method 1: Manual Flutter Installation (Most Reliable)**

### **Step 1: Download Flutter SDK**

1. **Visit**: https://docs.flutter.dev/get-started/install/macos
2. **Download**: Flutter SDK for macOS (Intel or Apple Silicon)
3. **Extract** to a permanent location:
   ```bash
   # Recommended location
   cd ~/
   unzip ~/Downloads/flutter_macos_*.zip
   ```

### **Step 2: Add Flutter to PATH**

1. **Open Terminal** and edit your shell profile:

   ```bash
   # For zsh (default on newer macOS)
   nano ~/.zshrc

   # For bash (older macOS)
   nano ~/.bash_profile
   ```

2. **Add Flutter to PATH** (add this line):

   ```bash
   export PATH="$PATH:$HOME/flutter/bin"
   ```

3. **Reload your shell**:
   ```bash
   source ~/.zshrc
   # or
   source ~/.bash_profile
   ```

### **Step 3: Verify Installation**

```bash
flutter --version
flutter doctor
```

## 🛠️ **Method 2: Homebrew Installation (If Homebrew Available)**

1. **Install Homebrew** (if not installed):

   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install Flutter**:
   ```bash
   brew install --cask flutter
   ```

## 🎯 **Method 3: Use VS Code Flutter Extension**

## 🏃‍♂️ **Method 3: Quick Test with VS Code**

1. **Open Frontend Folder** in VS Code
2. **Look for Flutter indicators** in the status bar
3. **Try opening** `lib/main.dart` - VS Code should recognize it as Flutter
4. **Use Debug/Run options** in VS Code (if Flutter is detected)

## ✅ **Once Flutter is Working**

Run these commands in the frontend directory:

```bash
flutter doctor          # Check everything is setup
flutter pub get         # Install all dependencies
flutter run             # Start the app (will show device options)
```

## 📱 **Running on Different Platforms**

- **Web Browser**: `flutter run -d chrome`
- **iOS Simulator**: `flutter run -d ios` (macOS only)
- **Android Emulator**: `flutter run -d android`

## 🔧 **If VS Code Shows Flutter Options**

If VS Code already shows Flutter options in the Command Palette or status bar, it means Flutter might be partially configured. Try:

1. Open `lib/main.dart` in VS Code
2. Look for a "Run" or "Debug" button above the `main()` function
3. Click it to run the app

## 💡 **Troubleshooting**

If you see Flutter options in VS Code but can't run from terminal:

- Flutter might be installed but not in system PATH
- VS Code extension might use its own Flutter installation
- Try running from VS Code first, then fix PATH later

---

**The ConnectFlavour frontend is ready to run as soon as Flutter SDK is available!** 🍳✨
