# Layout Issue Summary

## Problem

All three rewritten pages (Home, Create Recipe, Recipe Detail) compile without errors but render as empty white screens. The console shows "BoxConstraints forces an infinite width" errors.

## Root Cause

`MainNavigation` wraps all pages in a `ShellRoute` and uses this structure:

```dart
Row(
  children: [
    NavigationRail(...),
    VerticalDivider(),
    Expanded(
      child: widget.child, // The pages go here
    ),
  ],
)
```

The `Expanded` widget inside a `Row` passes infinite width constraints to its child. The new clean pages don't properly handle these constraints, causing rendering failures.

## Stack Trace

```
BoxConstraints forces an infinite width.
The offending constraints were:
  BoxConstraints(w=Infinity, 35.7<=h<=Infinity)

The relevant error-causing widget was:
  OutlinedButton (in desktop_create_recipe_page.dart)
```

## Pages Affected

1. `desktop_home_page.dart` - Recipe browsing page
2. `desktop_create_recipe_page.dart` - Recipe creation form
3. `desktop_recipe_detail_page.dart` - Recipe details view

## Current Page Structure

All pages use:

```dart
Scaffold(
  body: Column(
    children: [
      Header widget,
      Expanded(
        child: Content (SingleChildScrollView, GridView, etc.)
      ),
    ],
  ),
)
```

This structure should work, but nested widgets inside (especially `Row` widgets with buttons) are getting infinite width constraints cascading down from the parent `Expanded`.

## Attempted Fixes

1. ✅ Added `SafeArea` wrapper - didn't help
2. ✅ Wrapped buttons in `Flexible` - didn't help
3. ✅ Added `LayoutBuilder` with bounded constraints - syntax errors occurred
4. ✅ Used `SizedBox(width: double.infinity)` - didn't help
5. ❌ All attempts failed - app crashes on load

## Solution Options

### Option 1: Fix MainNavigation (Recommended)

Modify `MainNavigation` to not use `Expanded` or to properly constrain the child:

```dart
Expanded(
  child: ConstrainedBox(
    constraints: BoxConstraints(
      maxWidth: double.infinity,
      minWidth: 0,
    ),
    child: widget.child,
  ),
)
```

### Option 2: Fix Each Page

Ensure all pages and their child widgets properly handle infinite width constraints by:

- Wrapping all `Row` widgets containing buttons in `IntrinsicWidth` or specific width constraints
- Using `Flexible` or `Expanded` for all children of `Row` widgets
- Avoiding nested `Row` widgets without proper constraints

### Option 3: Reference Working Pages

Check existing working pages like `DesktopProfilePage` or `DesktopCategoriesPage` to see how they handle the MainNavigation wrapper and replicate their structure.

## Next Steps

1. Compare with working pages to understand their structure
2. Either fix MainNavigation OR restructure all three pages to match working examples
3. Test incrementally - fix one page first, then apply pattern to others
4. Document the solution for future page development

## Files to Check

- `/frontend/lib/shared/widgets/main_navigation.dart` - Navigation wrapper
- `/frontend/lib/features/profile/presentation/pages/desktop_profile_page.dart` - Working example
- `/frontend/lib/features/categories/presentation/pages/desktop_categories_page.dart` - Working example
- `/frontend/lib/config/router_config.dart` - Routing configuration

## Impact

- ✅ Navigation works (Home link → Recipes link successful)
- ✅ All pages compile without Dart errors
- ❌ Pages render empty due to layout constraints
- ❌ App crashes with BoxConstraints errors
- ❌ User cannot use create recipe or view recipe details
