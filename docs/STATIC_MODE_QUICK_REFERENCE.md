# Static Data Mode - Quick Reference

## 🎯 What Works Without Backend

### ✅ Fully Functional Features

- **Browse all recipes** (14 pre-loaded)
- **Search & filter recipes** (category, difficulty, keywords)
- **View recipe details** (ingredients, instructions, nutrition)
- **Create new recipes** (stored in session)
- **Favorite/unfavorite recipes** (persisted locally)
- **Edit user profile** (name, bio, location, avatar)
- **Browse categories** (8 categories)
- **View user activity**
- **All UI interactions**

### ⚠️ Requires Backend

- Login
- Registration
- Password reset

## 🚀 Quick Start

1. **Run the app** - Everything works immediately
2. **No backend needed** - All data is static + session storage
3. **All changes persist** - Restarting the app keeps your data

## 📊 Pre-loaded Data

- **14 Recipes** across 8 categories
- **8 Categories** (Breakfast, Lunch, Dinner, Desserts, etc.)
- **4 Users** with complete profiles
- **Sample reviews** for all recipes

## 💾 Where Data is Stored

All user actions are stored locally:

```
SharedPreferences (Browser Local Storage / Device Storage)
├── user_recipes          # Your created recipes
├── favorite_recipe_ids   # Your favorites
├── current_user          # Your profile
└── user_categories       # Custom categories
```

## 🔧 Key Services

```dart
StaticRecipeService()    // Recipes + user creations
StaticCategoryService()  // Categories
StaticUserService()      // User profile & session
StorageService           // JSON persistence layer
```

## 📝 Example: Creating a Recipe

```dart
// User fills form and submits
// Recipe is automatically:
// 1. Given unique ID
// 2. Saved to session storage
// 3. Available immediately
// 4. Persisted on app restart
```

## 🔄 Switching to API Mode

Change imports from:

```dart
import 'static_recipe_service.dart';
```

To:

```dart
import 'recipe_service.dart';
```

That's it! Same interface, different data source.

## 📂 Important Files

```
lib/core/
├── data/static_data.dart              # All static data
├── services/
│   ├── storage_service.dart           # Local storage
│   ├── static_recipe_service.dart     # Recipe operations
│   ├── static_category_service.dart   # Category operations
│   └── static_user_service.dart       # User operations
```

## 🎨 Sample Recipes Available

1. Classic French Toast
2. Avocado Toast with Poached Egg
3. Blueberry Pancakes
4. Caesar Salad with Grilled Chicken
5. Mediterranean Quinoa Bowl
6. Spaghetti Carbonara
7. Grilled Salmon with Lemon Herb Butter
8. Chicken Tikka Masala
9. Chocolate Lava Cake
10. Classic Tiramisu
11. Bruschetta with Tomato and Basil
12. Mango Smoothie Bowl
13. Homemade Hummus
14. Greek Salad

## 💡 Tips

- **Data persists** - Your created recipes survive app restarts
- **No internet needed** - Everything works offline
- **Realistic behavior** - Network delays simulated for UX
- **Full CRUD** - Create, read, update, delete all work
- **Multi-user ready** - Can simulate different users

## 🐛 Troubleshooting

**Q: My created recipe disappeared**
A: Check browser/device storage wasn't cleared

**Q: Can I add more static recipes?**
A: Yes! Edit `lib/core/data/static_data.dart`

**Q: How to reset to defaults?**
A: Clear app data or call `StorageService.clear()`

**Q: Can I use the API too?**
A: Yes, just keep login/register using the real API

---

**Mode**: Static Data + Session Storage  
**Last Updated**: November 27, 2025
