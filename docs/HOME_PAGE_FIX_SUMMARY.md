# Home Page Fix Summary

## Date: November 27, 2024

## Issue

Home page was showing blank despite backend being operational.

## Root Cause Analysis

### 1. **Recipe Model Type Mismatch**

The main issue was a mismatch between the API response structure and the Recipe model's `fromJson` method:

**API Response Structure:**

```json
{
  "author": {
    "id": 21,
    "username": "mary_cook",
    "first_name": "Mary",
    "last_name": "Cook",
    "full_name": "Mary Cook",
    "profile_picture": null,
    "followers_count": 0,
    "recipes_count": 2,
    "is_verified": false
  },
  "category_name": "Breakfast",
  "difficulty_name": "Easy",
  "average_rating": "4.5",
  "featured_image": "..."
}
```

**Model Expected:**

- `author` as String (but API returns nested object)
- `category` field (but API uses `category_name`)
- `difficulty` field (but API uses `difficulty_name`)
- `rating` as double (but API uses `average_rating` as string)
- `image` field (but API uses `featured_image`)

**Error:**

```
TypeError: Instance of '_JsonMap': type '_JsonMap' is not a subtype of type 'String'
```

### 2. **Layout Rendering Issues**

Dropdown filters in home page were not properly constrained, causing infinite width errors:

```
BoxConstraints(unconstrained)
RenderConstrainedBox with BoxConstraints(w=Infinity)
```

## Fixes Applied

### 1. Recipe Model (`frontend/lib/core/models/recipe.dart`)

Updated `fromJson` factory method to:

- Handle nested author object and extract `full_name` or `username`
- Use correct API field names (`category_name`, `difficulty_name`, `featured_image`)
- Parse `average_rating` string to double with helper function
- Provide fallbacks for both old and new field names for backward compatibility

```dart
factory Recipe.fromJson(Map<String, dynamic> json) {
  // Handle author - can be object or string
  String authorId = '';
  String authorName = '';
  if (json['author'] is Map) {
    final authorObj = json['author'] as Map<String, dynamic>;
    authorId = authorObj['id']?.toString() ?? '';
    authorName = authorObj['full_name'] ?? authorObj['username'] ?? '';
  } else if (json['author'] is String) {
    authorId = json['author'];
    authorName = json['author_name'] ?? '';
  }

  return Recipe(
    // ... other fields
    image: json['featured_image'] ?? json['image'],
    category: json['category_name'] ?? json['category'] ?? '',
    difficulty: json['difficulty_name'] ?? json['difficulty'] ?? 'Medium',
    author: authorId,
    authorName: authorName,
    rating: _parseDouble(json['average_rating'] ?? json['rating'] ?? 0.0),
    reviewCount: json['rating_count'] ?? json['review_count'] ?? 0,
    isFavorite: json['is_saved'] ?? json['is_favorite'] ?? false,
    // ... other fields
  );
}

static double _parseDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0.0;
  return 0.0;
}
```

### 2. Layout Fix (`frontend/lib/features/recipes/presentation/pages/desktop_home_page.dart`)

Wrapped dropdown filters in `Flexible` widgets to prevent infinite width:

```dart
Widget _buildSearchAndFilters() {
  return Row(
    children: [
      Expanded(
        flex: 2,
        child: TextField(/* search field */),
      ),
      const SizedBox(width: 16),
      Flexible(child: _buildCategoryFilter()),  // Added Flexible
      const SizedBox(width: 16),
      Flexible(child: _buildDifficultyFilter()), // Added Flexible
    ],
  );
}
```

## Verification Steps

1. ✅ Backend running on `http://localhost:8000`
2. ✅ API returning proper data:
   - `GET /api/v1/recipes/` - Returns 10 recipes
   - `GET /api/v1/categories/` - Returns 15 categories
3. ✅ Recipe model parsing API responses correctly
4. ✅ Flutter app launched successfully
5. ✅ App accessible at `http://localhost:56170`
6. ✅ No layout rendering errors

## API Field Mapping Reference

| Model Field   | API Field                               | Type            | Notes                        |
| ------------- | --------------------------------------- | --------------- | ---------------------------- |
| `author`      | `author.id`                             | String          | Extracted from nested object |
| `authorName`  | `author.full_name` or `author.username` | String          | Fallback to username         |
| `category`    | `category_name`                         | String          | Changed from `category`      |
| `difficulty`  | `difficulty_name`                       | String          | Changed from `difficulty`    |
| `rating`      | `average_rating`                        | String → Double | Needs parsing                |
| `reviewCount` | `rating_count`                          | Int             | Changed from `review_count`  |
| `isFavorite`  | `is_saved`                              | Boolean         | Changed from `is_favorite`   |
| `image`       | `featured_image`                        | String          | Changed from `image`         |

## Known Warnings (Non-Critical)

- `file_picker` package warnings for Linux/macOS/Windows platforms
  - These are just warnings about inline implementations
  - Don't affect web functionality
  - Can be safely ignored

## Testing Recommendations

1. Verify recipe cards display on home page
2. Test category and difficulty filters
3. Check recipe detail pages
4. Verify profile page with new UI
5. Test recipe creation/editing if using same model

## Future Considerations

1. **Backend Consistency**: Consider standardizing field names across all endpoints
2. **Type Safety**: Add API response validation layer
3. **Error Handling**: Add better error messages for parsing failures
4. **Documentation**: Update API documentation to reflect current field names
