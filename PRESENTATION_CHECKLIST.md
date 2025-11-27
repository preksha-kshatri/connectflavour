# 📋 Presentation Checklist

## Pre-Presentation Setup (30 minutes before)

### 1. Environment Check ✅

- [ ] **Python installed** - Run `python --version` (should be 3.8+)
- [ ] **Flutter installed** - Run `flutter --version`
- [ ] **VS Code/IDE ready** - Project open in editor
- [ ] **Browser ready** - Chrome/Firefox with dev tools
- [ ] **Terminal ready** - 2 terminal windows open

---

### 2. Backend Setup ✅

```bash
# Terminal 1: Backend
cd backend/connectflavour

# Check dependencies
pip list | grep Django

# Start server
python manage.py runserver
```

**Expected Output:**

```
Starting development server at http://127.0.0.1:8000/
Quit the server with CTRL-BREAK.
```

**Verify:**

- [ ] No errors in console
- [ ] Open `http://localhost:8000/admin` - Should load admin login
- [ ] Open `http://localhost:8000/api/v1/recipes/` - Should return JSON

---

### 3. Database Seeding ✅

```bash
# In backend terminal
python manage.py seed_data --clear
```

**Expected Output:**

```
Clearing existing data...
✓ Cleared existing data
Seeding database...
✓ Created 8 users
✓ Created 15 categories
✓ Created 3 difficulty levels
✓ Created 10 recipes
✓ Created 38 reviews
✓ Created 34 favorites

✓ Database seeding completed successfully!
```

**Verify:**

- [ ] All items created without errors
- [ ] Open `http://localhost:8000/admin`
- [ ] Login with superuser
- [ ] Check Recipes table - should have 10 recipes
- [ ] Check Users table - should have 8+ users

---

### 4. Frontend Setup ✅

```bash
# Terminal 2: Frontend
cd frontend

# Install dependencies (if needed)
flutter pub get

# Run app
flutter run -d windows
# OR
flutter run -d chrome
```

**Expected Output:**

```
Launching lib\main.dart on Windows in debug mode...
Building Windows application...
Syncing files to device Windows...
```

**Verify:**

- [ ] App launches without errors
- [ ] Login page appears
- [ ] No red error screens

---

### 5. Test Login ✅

**Use these credentials:**

- Username: `john_chef`
- Password: `password123`

**After login, verify:**

- [ ] Home page shows recipes (should see 10 recipes)
- [ ] Categories page shows 15 categories
- [ ] Profile page shows user info
- [ ] No errors in console

---

### 6. Browser Tools Setup ✅

**Open in Browser:**

- [ ] `http://localhost:8000/api/schema/swagger-ui/` - Swagger API docs
- [ ] `http://localhost:8000/admin` - Django admin (keep logged in)

**Chrome DevTools:**

- [ ] Open DevTools (F12)
- [ ] Go to Network tab
- [ ] Check "Preserve log"
- [ ] Clear console

---

## Presentation Flow (15 minutes)

### Introduction (2 min)

**Script:**

> "Good [morning/afternoon]. Today I'll present ConnectFlavour, a full-stack recipe sharing platform built with Flutter and Django REST Framework."

**Show:**

- [ ] App running on screen
- [ ] Quick tour of home page

**Key Points:**

- Cross-platform (Windows, Web, Mobile)
- 100% dynamic (all data from API)
- Production-ready with proper error handling

---

### Tech Stack Overview (3 min)

**Script:**

> "The application uses modern technologies: Flutter for the frontend with Material Design 3, and Django REST Framework for a robust backend API."

**Show:**

- [ ] VS Code with project open
- [ ] Show `frontend/lib` folder structure
- [ ] Show `backend/connectflavour/apps` folder structure
- [ ] Highlight the clean architecture

**Key Points:**

- Frontend: Flutter, Dart, Dio, go_router
- Backend: Django, DRF, JWT, SQLite
- Clear separation of concerns

---

### Feature Demonstration (7 min)

#### A. Browse Recipes (1.5 min)

**Show:**

- [ ] Home page with recipe grid
- [ ] Search bar - type "pasta" and show results
- [ ] Category filter - select "Desserts"
- [ ] Difficulty filter - select "Easy"
- [ ] Clear filters

**Narrate:**

> "Users can browse all recipes with real-time search and filtering by category and difficulty."

---

#### B. Recipe Details (1.5 min)

**Show:**

- [ ] Click on "Spaghetti Carbonara"
- [ ] Show breadcrumb navigation
- [ ] Click through tabs: Ingredients, Instructions, Nutrition, Reviews
- [ ] Click favorite button (toggle on/off)
- [ ] Show reviews with star ratings

**Narrate:**

> "Each recipe has complete details including ingredients, step-by-step instructions, nutritional information, and user reviews."

---

#### C. Create Recipe (1.5 min)

**Show:**

- [ ] Click "Create Recipe" button
- [ ] Fill in title: "Test Recipe"
- [ ] Click "Select Image" - choose an image
- [ ] Add ingredient - type "2 cups flour"
- [ ] Add another ingredient
- [ ] Add instruction - type "Mix ingredients"
- [ ] Show remove button for dynamic fields
- [ ] Select category and difficulty
- [ ] Click "Create Recipe"
- [ ] Show success and navigation to new recipe

**Narrate:**

> "Users can create recipes with image upload and dynamic ingredient/instruction fields."

---

#### D. Categories (1 min)

**Show:**

- [ ] Navigate to Categories page
- [ ] Show category grid with icons
- [ ] Show recipe counts
- [ ] Search for "vegetarian"
- [ ] Click on a category

**Narrate:**

> "Browse recipes organized by 15 different categories, all dynamically loaded from the API."

---

#### E. Profile & Social (1.5 min)

**Show:**

- [ ] Navigate to Profile
- [ ] Show "My Recipes" tab (should show "Test Recipe" you just created)
- [ ] Show "Favorites" tab (favorited recipes)
- [ ] Show "Activity" tab
- [ ] Click "Edit Profile" button
- [ ] Show avatar upload
- [ ] Click "Settings" button
- [ ] Show change password dialog

**Narrate:**

> "User profiles include all their recipes, favorites, and activity timeline. Users can edit their profile and manage settings."

---

### Technical Deep Dive (3 min)

#### A. API Integration (1.5 min)

**Show:**

- [ ] Open browser to Swagger UI: `http://localhost:8000/api/schema/swagger-ui/`
- [ ] Expand `/api/v1/recipes/` GET endpoint
- [ ] Click "Try it out" → "Execute"
- [ ] Show JSON response

**Show in Code:**

- [ ] Open `frontend/lib/core/services/api_service.dart`
- [ ] Highlight Dio client setup
- [ ] Show JWT token interceptor

**Narrate:**

> "The frontend communicates with a RESTful API. Here's the Swagger documentation showing all available endpoints. The API uses JWT authentication with automatic token refresh."

---

#### B. Dynamic Data Flow (1.5 min)

**Show:**

- [ ] Open `frontend/lib/features/recipes/presentation/pages/desktop_home_page.dart`
- [ ] Show `_loadRecipes()` method
- [ ] Show `RecipeService.getRecipes()` call
- [ ] Show loading state handling
- [ ] Show error handling

**Show Network Tab:**

- [ ] Open Chrome DevTools Network tab
- [ ] Refresh the home page
- [ ] Show API call to `/api/v1/recipes/`
- [ ] Show response

**Narrate:**

> "Every page fetches real data from the API with proper loading states and error handling. No hardcoded content anywhere."

---

### Error Handling Demo (Optional, 1 min)

**Show:**

- [ ] Stop the backend server (Ctrl+C)
- [ ] Refresh app/navigate to a page
- [ ] Show error message with retry button
- [ ] Start backend server again
- [ ] Click retry button
- [ ] Show data loading

**Narrate:**

> "The app gracefully handles errors with user-friendly messages and retry options."

---

## Q&A Preparation

### Common Questions & Answers

**Q: How many platforms does it support?**

> A: Four platforms - Windows Desktop, Web (Chrome/Firefox), Android, and iOS. Same Flutter codebase for all.

**Q: Is the data real or hardcoded?**

> A: 100% real data from the API. We have a seeding script that generates realistic test data including 10 recipes, 8 users, 15 categories, and 38 reviews.

**Q: How is authentication handled?**

> A: JWT (JSON Web Tokens) with automatic refresh. Tokens are stored securely and attached to API requests via Dio interceptors.

**Q: Can users upload images?**

> A: Yes, users can upload recipe images. The frontend uses image_picker, and images are uploaded to the Django backend via multipart requests.

**Q: Is it production-ready?**

> A: Yes - it has proper error handling, loading states, authentication, image upload, and follows clean architecture principles.

**Q: How long did it take to build?**

> A: The initial mobile version was an academic project. The desktop migration and making everything fully dynamic took additional development time to ensure production quality.

**Q: Can you add more features?**

> A: Absolutely. The modular architecture makes it easy to add features like meal planning, shopping lists, recipe collections, social sharing, etc.

**Q: What database does it use?**

> A: SQLite for development, but it's configured to easily switch to PostgreSQL for production deployment.

**Q: How do you handle security?**

> A: JWT authentication, CORS configuration, input validation, password hashing with Django's built-in security, and proper error handling without exposing sensitive data.

**Q: Can it scale?**

> A: Yes - Django REST Framework is highly scalable. We can add caching (Redis), use PostgreSQL, add load balancing, and deploy to cloud platforms.

---

## Post-Presentation

### If Demo Fails

**Backend Issues:**

```bash
# Restart backend
cd backend/connectflavour
python manage.py runserver
```

**Frontend Issues:**

```bash
# Restart frontend
cd frontend
flutter run -d windows
```

**Database Issues:**

```bash
# Reseed database
python manage.py seed_data --clear
```

### Backup Plan

If live demo fails:

- [ ] Have screenshots ready in `docs/screenshots/` folder
- [ ] Have video recording as backup
- [ ] Show API docs in Swagger UI instead
- [ ] Show Django admin panel with data
- [ ] Walk through code without running app

---

## Final Checklist

### 5 Minutes Before Presentation

- [ ] Backend running on port 8000
- [ ] Frontend running without errors
- [ ] Logged in as `john_chef`
- [ ] Home page showing 10 recipes
- [ ] Browser tabs ready (Swagger UI, Django Admin)
- [ ] VS Code open with project
- [ ] DevTools Network tab open
- [ ] Terminal visible for commands
- [ ] Audio/video working (if remote)
- [ ] Screen sharing tested (if remote)

### During Presentation

- [ ] Speak clearly and at moderate pace
- [ ] Don't rush through features
- [ ] Highlight unique features (100% dynamic, cross-platform)
- [ ] Show both UI and code
- [ ] Use Network tab to show API calls
- [ ] Mention error handling and loading states
- [ ] End with Q&A invitation

### After Presentation

- [ ] Share GitHub link
- [ ] Share documentation (README.md)
- [ ] Provide quick start guide (QUICKSTART_UPDATED.md)
- [ ] Offer to help with setup if needed

---

## Time Allocation

| Section             | Time       | Content                                     |
| ------------------- | ---------- | ------------------------------------------- |
| Introduction        | 2 min      | Overview & tech stack                       |
| Tech Stack          | 3 min      | Architecture & folder structure             |
| Feature Demo        | 7 min      | Browse, detail, create, categories, profile |
| Technical Deep Dive | 3 min      | API integration & data flow                 |
| Q&A                 | 5+ min     | Answer questions                            |
| **Total**           | **20 min** | Complete presentation                       |

---

## Success Criteria

✅ **Presentation is successful if:**

- App runs without crashes
- Can browse recipes
- Can create a new recipe
- Can view recipe details
- Can show API documentation
- Can explain the architecture
- Can answer questions confidently

---

**Good luck with your presentation! 🎉**

**Remember:** This is a production-ready application with professional UI, robust backend, and clean code. Be confident!
