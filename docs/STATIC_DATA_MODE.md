# Static Data Mode Implementation

## Overview

The ConnectFlavour application has been configured to work entirely with **static data** and **session/cookie storage**, eliminating the need for a live backend API. This allows the application to function fully offline while maintaining state across sessions.

## Architecture

### Core Components

#### 1. **Static Data Provider** (`lib/core/data/static_data.dart`)

- Contains pre-populated, realistic data for:
  - **14 Recipes** across 8 categories (Breakfast, Lunch, Dinner, Desserts, Appetizers, Beverages, Snacks, Salads)
  - **8 Categories** with icons and descriptions
  - **4 Users** with complete profiles
- All data is hardcoded and immediately available

#### 2. **Enhanced Storage Service** (`lib/core/services/storage_service.dart`)

Extended to support:

- **JSON storage** for complex objects
- **JSON list storage** for arrays
- **Session persistence** using SharedPreferences
- All CRUD operations for user-created content

#### 3. **Static Service Layer**

Three dedicated services handle data operations:

**StaticRecipeService** (`lib/core/services/static_recipe_service.dart`)

- Loads static recipes + user-created recipes from storage
- Manages favorites via session storage
- Supports full CRUD operations
- Persists all changes to local storage

**StaticCategoryService** (`lib/core/services/static_category_service.dart`)

- Provides static categories
- Supports user-created categories in session

**StaticUserService** (`lib/core/services/static_user_service.dart`)

- Manages current user session
- Handles profile updates in storage
- Provides user activity data

## Features & Functionality

### ✅ Fully Working (Static Mode)

1. **Browse Recipes**

   - View all 14 pre-loaded recipes
   - Filter by category and difficulty
   - Search recipes by title, description, ingredients
   - View detailed recipe information

2. **Recipe Details**

   - Full recipe information with ingredients and instructions
   - Sample reviews for each recipe
   - Nutrition information
   - Author details

3. **Create Recipes**

   - Add new recipes with full details
   - Recipes stored in session storage
   - Persists across app restarts
   - Auto-generates unique IDs

4. **Favorites System**

   - Toggle recipe favorites
   - Persisted in session storage
   - View favorite recipes on profile

5. **User Profile**

   - View and edit profile information
   - Update bio, location, preferences
   - Changes saved to session storage
   - Avatar updates (simulated with placeholder URLs)

6. **Categories**
   - Browse 8 pre-loaded categories
   - View recipes by category
   - Support for user-created categories

### 🔄 Dynamic Only (Requires Backend)

1. **Authentication**
   - Login
   - Registration
   - Password reset

These remain connected to the backend API and require a live server.

## Data Storage Strategy

### Session Storage Keys

```dart
// Recipes
'user_recipes'        // User-created recipes (JSON array)
'favorite_recipe_ids' // List of favorited recipe IDs

// User
'current_user'        // Current logged-in user (JSON object)
'user_profile'        // User profile updates

// Categories
'user_categories'     // User-created categories (JSON array)
```

### Data Persistence

All user interactions are stored using `shared_preferences`:

- **User-created recipes** persist across sessions
- **Favorite status** is maintained
- **Profile changes** are saved locally
- **No data loss** on app restart

## Sample Data

### Recipes (14 total)

- **Breakfast**: French Toast, Avocado Toast, Blueberry Pancakes
- **Lunch**: Caesar Salad, Mediterranean Quinoa Bowl
- **Dinner**: Spaghetti Carbonara, Grilled Salmon, Chicken Tikka Masala
- **Desserts**: Chocolate Lava Cake, Classic Tiramisu
- **Appetizers**: Bruschetta
- **Beverages**: Mango Smoothie Bowl
- **Snacks**: Homemade Hummus
- **Salads**: Greek Salad

### Users (4 total)

- Emily Johnson (chef_emily) - Professional chef
- Mark Chen (healthyeats_mark) - Nutritionist
- Sarah Martinez (pasta_lover_sarah) - Italian cuisine specialist
- James Wilson (baker_james) - Pastry chef

## Implementation Details

### Recipe Creation Flow

```dart
1. User fills out recipe form
2. Recipe object created with:
   - Auto-generated ID (max existing ID + 1)
   - Current user as author
   - Current timestamp
   - All form data
3. Recipe added to user_recipes array in storage
4. Navigation to new recipe detail page
```

### Favorite Toggle Flow

```dart
1. User clicks favorite button
2. Recipe ID added/removed from favorite_recipe_ids
3. Recipe list re-loaded with updated favorite status
4. UI updates immediately
```

### Profile Update Flow

```dart
1. User edits profile information
2. Updated user object saved to current_user key
3. Profile page reloads with new data
4. Changes visible immediately
```

## Session Management

### Current User

The first static user (Emily Johnson) is used as the default logged-in user. This can be changed by:

```dart
await StaticUserService().setCurrentUser(differentUser);
```

### Data Isolation

Each user's created recipes and favorites are stored globally but attributed to their user ID, allowing for multi-user simulation.

## Benefits of Static Mode

✅ **No Backend Required** - App works completely offline
✅ **Instant Loading** - No network delays
✅ **Persistent State** - All changes saved locally
✅ **Full Functionality** - All features except auth work
✅ **Easy Testing** - Consistent, predictable data
✅ **Development Speed** - No API dependency

## Switching Modes

To switch back to API mode, simply replace:

```dart
StaticRecipeService → RecipeService
StaticCategoryService → CategoryService
StaticUserService → UserService
```

The interfaces are identical, making the transition seamless.

## File Structure

```
lib/
├── core/
│   ├── data/
│   │   └── static_data.dart          # All static data
│   ├── services/
│   │   ├── storage_service.dart       # Enhanced storage with JSON support
│   │   ├── static_recipe_service.dart # Recipe operations
│   │   ├── static_category_service.dart # Category operations
│   │   └── static_user_service.dart   # User operations
│   └── models/
│       ├── recipe.dart               # Recipe, RecipeStep, Review, NutritionInfo
│       ├── user.dart                 # User, Activity
│       └── category.dart             # Category
└── features/
    ├── recipes/
    │   └── presentation/pages/
    │       ├── desktop_home_page.dart
    │       ├── desktop_recipe_detail_page.dart
    │       └── desktop_create_recipe_page.dart
    ├── profile/
    │   └── presentation/pages/
    │       └── desktop_profile_page.dart
    └── categories/
        └── presentation/pages/
            └── desktop_categories_page.dart
```

## Testing the Implementation

1. **Browse Recipes**: Open app → See 14 recipes loaded
2. **Create Recipe**: Click "Create Recipe" → Fill form → Submit → Recipe appears in list
3. **Toggle Favorite**: Click heart icon → Favorite persists on reload
4. **Edit Profile**: Go to profile → Edit → Changes saved
5. **Restart App**: Close and reopen → All changes still present

## Notes

- All image URLs use Unsplash placeholders
- User avatars use pravatar.cc for consistency
- Network delays simulated with `Future.delayed()` for realistic UX
- Error handling maintains same patterns as API mode
- All data types match the original API response structures

---

**Last Updated**: November 27, 2025
**Mode**: Static Data with Session Storage
**Backend Required**: Only for Login/Registration
