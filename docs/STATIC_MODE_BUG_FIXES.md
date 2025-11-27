# Static Mode Bug Fixes

## Overview

Two critical bugs were discovered and fixed that prevented the Categories and Create Recipe pages from displaying on web.

---

## Bug #1: Categories Page Icon Mapping Error

### Problem

Categories page showed blank screen with no visible errors in compile logs.

### Root Cause

1. Categories in `static_data.dart` use emoji strings in the `icon` field:

   ```dart
   icon: '🍳'  // breakfast
   icon: '🥗'  // lunch
   icon: '🍽️'  // dinner
   ```

2. The `_buildCategoryCard` method tried to use these emoji strings directly:

   ```dart
   _getIconData(category.icon ?? 'restaurant')  // ❌ Passes emoji string
   ```

3. The `_iconMap` dictionary expected category slugs, not emojis:

   ```dart
   final _iconMap = {
     'breakfast': Icons.restaurant,
     'lunch': Icons.restaurant_menu,
     // etc.
   }
   ```

4. When `_getIconData()` received an emoji string like '🍳', it couldn't find it in the map, causing a runtime error.

### Solution

Changed the icon mapping to use `category.slug` instead of `category.icon`:

**Before:**

```dart
CircleAvatar(
  backgroundColor: _getCategoryColor(index),
  radius: 30,
  child: Icon(
    _getIconData(category.icon ?? 'restaurant'),  // ❌
    color: Colors.white,
    size: 28,
  ),
),
```

**After:**

```dart
CircleAvatar(
  backgroundColor: _getCategoryColor(index),
  radius: 30,
  child: Icon(
    _getIconData(category.slug),  // ✅ Use slug instead
    color: Colors.white,
    size: 28,
  ),
),
```

Also added missing 'snacks' entry to `_iconMap`:

```dart
final _iconMap = {
  'breakfast': Icons.restaurant,
  'lunch': Icons.restaurant_menu,
  'dinner': Icons.dinner_dining,
  'dessert': Icons.cake,
  'vegan': Icons.eco,
  'beverages': Icons.local_cafe,
  'snacks': Icons.fastfood,  // ✅ Added
  'healthy': Icons.favorite,
};
```

### Files Modified

- `lib/features/categories/presentation/pages/desktop_categories_page.dart`

---

## Bug #2: Create Recipe Page Web Compatibility Error

### Problem

Create recipe page showed blank screen on web platform.

### Root Cause

1. Page imported `dart:io` which is **not available on web**:

   ```dart
   import 'dart:io';  // ❌ Web incompatible
   ```

2. Used `File` class to display selected images:

   ```dart
   image: FileImage(File(_selectedImagePath!)),  // ❌ Requires dart:io
   ```

3. When running on web, `dart:io` import causes the entire file to fail loading.

### Solution

**Step 1:** Removed `dart:io` import

```dart
// Before
import 'dart:io';  // ❌

// After
// No dart:io import  // ✅
```

**Step 2:** Changed image display to use NetworkImage with uploaded URL

```dart
// Before
image: _selectedImagePath != null
    ? DecorationImage(
        image: FileImage(File(_selectedImagePath!)),  // ❌
        fit: BoxFit.cover,
      )
    : null,

// After
image: _uploadedImageUrl != null
    ? DecorationImage(
        image: NetworkImage(_uploadedImageUrl!),  // ✅
        fit: BoxFit.cover,
      )
    : null,
```

**Step 3:** Removed unused `_selectedImagePath` field

```dart
// Removed
String? _selectedImagePath;  // ❌

// Already have
String? _uploadedImageUrl;  // ✅ Keep this
```

**Step 4:** Updated `_pickImage()` to not set removed field

```dart
// Before
if (image != null) {
  setState(() {
    _selectedImagePath = image.path;  // ❌
    _isUploadingImage = true;
  });
  // ...
}

// After
if (image != null) {
  setState(() {
    _isUploadingImage = true;  // ✅ Removed _selectedImagePath
  });
  // ...
}
```

### Files Modified

- `lib/features/recipes/presentation/pages/desktop_create_recipe_page.dart`

---

## Testing Results

### Before Fixes

❌ Categories page: Blank screen  
❌ Create recipe page: Blank screen  
✅ Home page: Working  
✅ Recipe detail page: Working  
✅ Profile page: Working

### After Fixes

✅ Categories page: Working - displays 8 categories in grid  
✅ Create recipe page: Working - full form with web-compatible image upload  
✅ Home page: Working  
✅ Recipe detail page: Working  
✅ Profile page: Working

**Status:** 5/5 pages working ✅

---

## Key Lessons

### Lesson 1: Data Field Usage

When data fields contain presentation values (like emoji icons), don't use them directly for logic. Use semantic identifiers (like slugs) instead.

### Lesson 2: Web Platform Compatibility

- **Never import `dart:io` in Flutter web code**
- Use conditional imports or platform checks when file system access is needed
- Prefer `NetworkImage` over `FileImage` for web compatibility
- Use `kIsWeb` from `package:flutter/foundation.dart` for platform detection

### Lesson 3: Runtime vs Compile Errors

Both bugs had **no compile errors** but caused runtime failures:

- Icon mapping failed at runtime when emoji couldn't be found in map
- `dart:io` import prevented file from loading on web platform

Always test on target platform (web) to catch these issues.

---

## Files Summary

### Categories Page Fix

**File:** `lib/features/categories/presentation/pages/desktop_categories_page.dart`  
**Changes:**

1. Line ~170-300: Changed `category.icon` to `category.slug` in `_buildCategoryCard()`
2. Added 'snacks' to `_iconMap` dictionary

### Create Recipe Page Fix

**File:** `lib/features/recipes/presentation/pages/desktop_create_recipe_page.dart`  
**Changes:**

1. Line 1-7: Removed `import 'dart:io';`
2. Line ~40: Removed `String? _selectedImagePath;` field
3. Line ~77: Removed `_selectedImagePath = image.path;` from `_pickImage()`
4. Line ~379: Changed from `FileImage(File(...))` to `NetworkImage(...)`
5. Line ~387: Changed condition from `_selectedImagePath == null` to `_uploadedImageUrl == null`

---

**Fixed:** December 2024  
**Status:** All bugs resolved ✅  
**Impact:** 2 pages restored to working state
