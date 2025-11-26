# Quick Start Guide

## 🚀 Running the Application

### Prerequisites

- Python 3.x installed
- Flutter SDK installed
- Django backend dependencies installed
- Flutter dependencies installed

### Step 1: Start the Backend

```bash
cd backend/connectflavour
python manage.py runserver
```

The API will be available at: `http://localhost:8000`

### Step 2: Seed the Database (First Time Only)

```bash
python manage.py seed_data --clear
```

This creates:

- 8 test users
- 15 categories
- 10 recipes with ingredients and instructions
- 38 reviews
- 34 favorites

### Step 3: Start the Frontend

```bash
cd frontend
flutter run -d windows    # For Windows desktop
# OR
flutter run -d chrome     # For web browser
```

### Step 4: Login

Use any of these test accounts:

- **Username:** john_chef, mary_cook, david_baker, sarah_grill, mike_pasta, lisa_vegan, tom_asian, emma_dessert
- **Password:** password123

---

## 🎯 All Features are Dynamic

Every page now fetches data from the API:

### ✅ Home Page

- Displays all recipes from database
- Real-time search and filters
- Click any recipe to view details

### ✅ Categories Page

- Shows all categories from database
- Search functionality
- Click to filter recipes by category

### ✅ Recipe Detail Page

- Fetches recipe data via API
- Shows ingredients, instructions, nutrition
- Displays reviews and ratings
- Favorite toggle works

### ✅ Create Recipe Page

- Submits to API
- Uploads images to server
- Dynamic ingredient/instruction fields

### ✅ Profile Page

- Fetches user data from API
- Edit profile with avatar upload
- Settings (change password, delete account)
- Dynamic tabs:
  - My Recipes (from API)
  - Favorites (from API)
  - Activity (from API)

---

## 🎨 UI Features

- **Professional Design:** Consistent green color scheme (#2E7D32)
- **Responsive Layout:** Works on desktop and web
- **Loading States:** Shows spinners while fetching data
- **Error Handling:** Retry buttons when API fails
- **Empty States:** Helpful messages when no data
- **Navigation:** Breadcrumbs on all pages
- **Collapsible Sidebar:** Starts minimized by default

---

## 📚 API Endpoints Used

All endpoints are at `http://localhost:8000/api/v1/`

### Recipes

- `GET /recipes/` - List all recipes
- `GET /recipes/{slug}/` - Get recipe detail
- `POST /recipes/` - Create recipe
- `PUT /recipes/{slug}/` - Update recipe
- `DELETE /recipes/{slug}/` - Delete recipe
- `POST /recipes/{slug}/favorite/` - Toggle favorite
- `GET /recipes/{slug}/reviews/` - Get reviews
- `POST /recipes/{slug}/reviews/` - Add review

### Categories

- `GET /categories/` - List all categories
- `GET /categories/{slug}/` - Get category detail

### Users

- `GET /users/me/` - Get current user
- `PUT /users/me/` - Update profile
- `POST /users/me/avatar/` - Upload avatar
- `GET /users/me/recipes/` - Get user's recipes
- `GET /users/me/favorites/` - Get favorites
- `GET /users/me/activity/` - Get activity timeline

### Auth

- `POST /auth/login/` - Login
- `POST /auth/register/` - Register
- `POST /auth/logout/` - Logout
- `POST /auth/token/refresh/` - Refresh token

---

## 🛠️ Troubleshooting

### Backend won't start

- Make sure you're in the `backend/connectflavour` directory
- Check that all dependencies are installed
- Verify Python version is 3.x

### Frontend won't start

- Make sure you're in the `frontend` directory
- Run `flutter pub get` to install dependencies
- Check Flutter SDK is properly installed

### No data showing

- Run the seed command: `python manage.py seed_data --clear`
- Check that backend is running on port 8000
- Verify API endpoints in browser: `http://localhost:8000/api/v1/recipes/`

### Images not uploading

- Check file size (should be under 5MB)
- Verify backend has write permissions
- Check media directory exists

---

## 📝 Test User Credentials

| Username     | Email             | Role             |
| ------------ | ----------------- | ---------------- |
| john_chef    | john@example.com  | Chef             |
| mary_cook    | mary@example.com  | Cook             |
| david_baker  | david@example.com | Baker            |
| sarah_grill  | sarah@example.com | Grill Master     |
| mike_pasta   | mike@example.com  | Pasta Expert     |
| lisa_vegan   | lisa@example.com  | Vegan Specialist |
| tom_asian    | tom@example.com   | Asian Cuisine    |
| emma_dessert | emma@example.com  | Dessert Maker    |

**All passwords:** password123

---

## ✨ What's New

1. **Home Page** - Completely rewritten to fetch recipes from API
2. **Categories Page** - Now dynamic with real category data
3. **Recipe Detail** - Full API integration with reviews and favorites
4. **Create Recipe** - Image upload and API submission working
5. **Profile Page** - Edit profile, settings, and all dynamic tabs
6. **Database** - Seeded with realistic test data
7. **UI** - Professional design throughout
8. **No Errors** - All compilation errors fixed

The application is now fully functional and production-ready! 🎉
