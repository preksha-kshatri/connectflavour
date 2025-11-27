# 🔐 Login Fix - Test Instructions

## ✅ What Was Fixed

The "Unable to load profile" error (and similar errors on all pages) was caused by **missing authentication**. The app was trying to access protected API endpoints without a valid JWT token.

### Changes Made:

1. **Created AuthService** (`core/services/auth_service.dart`)

   - Proper login/register implementation
   - Token storage using StorageService
   - Token verification

2. **Updated Login Page** (`features/authentication/presentation/pages/desktop_login_page.dart`)

   - Changed from email to username field
   - Integrated with real AuthService
   - Added error message display
   - Shows login errors to user

3. **Updated Splash Page** (`features/authentication/presentation/pages/splash_page.dart`)

   - Checks if user is already logged in
   - Verifies token validity before navigating
   - Auto-redirects to home if already authenticated

4. **Fixed API Endpoints**
   - Updated `/auth/me/` to `/auth/profile/`
   - Fixed token response parsing (backend returns nested `tokens` object)
   - Token refresh handled by interceptor

---

## 🧪 How to Test

### Step 1: Start Backend Server ✅ (Already Running)

```bash
cd backend/connectflavour
python manage.py runserver
```

Backend is running at: http://localhost:8000

### Step 2: Reload Frontend App

The Flutter app is already running at: http://localhost:52092

**Just refresh your browser (F5 or Ctrl+R)**

### Step 3: Login with Test Credentials

Use any of these **seeded test accounts**:

| Username      | Password      | Description                 |
| ------------- | ------------- | --------------------------- |
| `john_chef`   | `password123` | Main test user with recipes |
| `sarah_baker` | `password123` | User with baking recipes    |
| `mike_grill`  | `password123` | Grilling enthusiast         |
| `emma_cook`   | `password123` | Home cook                   |
| `david_pro`   | `password123` | Professional chef           |
| `lisa_vegan`  | `password123` | Vegan specialist            |
| `alex_fusion` | `password123` | Fusion cuisine expert       |
| `admin`       | `admin123`    | Admin account               |

**Recommended for testing:** Use `john_chef` / `password123`

### Step 4: What You Should See

#### ✅ After Login Success:

1. **Home Page** - Shows all recipes from database
2. **Categories Page** - Shows 15 categories with counts
3. **Create Recipe Page** - Form to create new recipe
4. **Profile Page** - Your user profile with tabs (My Recipes, Favorites, Activity)

#### ❌ Before Login:

- Splash screen → Login page
- All other pages redirect to login if not authenticated

---

## 🔍 Testing the Flow

### Test 1: Fresh Login

1. Open browser at http://localhost:52092
2. You'll see splash screen (3 seconds)
3. Redirects to login page
4. Enter: `john_chef` / `password123`
5. Click "Sign In" or press Enter
6. Should navigate to Home page with recipes

### Test 2: Browse Features

Once logged in:

- **Home** - Click any recipe to view details
- **Categories** - Filter recipes by category
- **Create** - Try creating a new recipe (with image upload)
- **Profile** - View your recipes and favorites

### Test 3: API Calls

Open Browser DevTools (F12) → Network tab:

- You should see `Authorization: Bearer <token>` in request headers
- All API calls to `/api/v1/*` should return 200 OK
- No more 401 Unauthorized errors

### Test 4: Logout (Manual)

Currently there's no logout button in the UI yet, but you can:

- Clear browser storage (Application → Storage → Clear)
- Refresh page - should redirect to login

---

## 🎯 Expected Behavior

### Authentication Flow:

```
Splash (3s)
  ↓
Check if logged in?
  ↓
  ├─ YES → Verify token → Home Page
  │                        ↓
  │                    (All features work)
  │
  └─ NO → Login Page
            ↓
         Enter credentials
            ↓
         Backend validates
            ↓
         Store JWT tokens
            ↓
         Navigate to Home
```

### API Request Flow:

```
User Action (e.g., view profile)
  ↓
API Service → GET /api/v1/auth/profile/
  ↓
Add Authorization header (from storage)
  ↓
Backend validates JWT token
  ↓
Return user data
  ↓
Display in UI
```

---

## 🐛 Troubleshooting

### Error: "Invalid username or password"

- Check you're using `username` not `email`
- Verify backend is running: http://localhost:8000
- Try test user: `john_chef` / `password123`

### Error: "Unable to load profile" (still appears)

1. Open DevTools → Console
2. Check for error messages
3. Go to Network tab
4. Look for failed requests (red)
5. Check if Authorization header is present

### Backend Not Running:

```bash
cd backend/connectflavour
python manage.py runserver
```

### Database Not Seeded:

```bash
cd backend/connectflavour
python manage.py seed_data --clear
```

### Clear Old Tokens (if stuck):

1. Open DevTools (F12)
2. Application tab → Storage
3. Clear all storage
4. Refresh page

---

## 📊 What Should Work Now

### ✅ Pages That Should Load:

- [x] **Login Page** - Form with username/password
- [x] **Home Page** - List of recipes from database
- [x] **Recipe Detail** - Full recipe with reviews
- [x] **Categories** - 15 categories with recipe counts
- [x] **Create Recipe** - Form with image upload
- [x] **Profile Page** - User info with tabs

### ✅ Features That Should Work:

- [x] **Login** - With test credentials
- [x] **Token Storage** - JWT tokens saved in browser
- [x] **Auto-redirect** - If not logged in
- [x] **API Calls** - All protected endpoints
- [x] **Search** - Recipe search on home page
- [x] **Filters** - Category and difficulty filters
- [x] **Image Display** - Recipe and user images
- [x] **Reviews** - View reviews on recipe detail
- [x] **Favorites** - View favorite recipes in profile

---

## 🎬 Quick Demo Script

**Perfect 2-minute test:**

1. **Refresh browser** → See splash screen
2. **Login page appears** → Enter `john_chef` / `password123`
3. **Press Enter** → Should redirect to Home
4. **Verify Home loads** → Should see 10 recipes
5. **Click a recipe** → Should open detail page
6. **Click Categories** → Should see 15 categories
7. **Click Profile** → Should show john_chef's profile

**If all 7 steps work → Authentication is FIXED! ✅**

---

## 🚀 Next Steps (Optional Enhancements)

### Add Logout Button to Profile:

1. Add button in profile app bar
2. Call `AuthService().logout()`
3. Navigate to login page
4. Clear stored tokens

### Add Remember Me:

1. Store username if checked
2. Pre-fill on next login

### Add Error Messages:

1. Network errors
2. Server errors
3. Invalid credentials

### Add Loading States:

1. Show spinner during login
2. Disable button while loading
3. Prevent double submissions

---

## 📝 Summary

**Problem:** App was not authenticated, so all API calls to protected endpoints failed with 401 errors.

**Solution:**

- Created proper AuthService
- Updated login page to use real authentication
- Fixed token storage and retrieval
- Updated all API endpoint paths

**Result:** Users can now login with test credentials and access all features!

---

## 🎓 For Presentation

When demonstrating:

1. **Mention the problem:** "Initially, pages showed errors because authentication wasn't implemented"

2. **Show the solution:** "We integrated JWT authentication with token storage and automatic header injection"

3. **Demonstrate:** "Let me login with a test user... and now all features work!"

4. **Highlight features:**
   - Token-based authentication
   - Automatic token refresh
   - Protected routes
   - Persistent sessions

---

<div align="center">

**Test with:** `john_chef` / `password123`

**Backend:** http://localhost:8000  
**Frontend:** http://localhost:52092  
**API Docs:** http://localhost:8000/api/docs/

✅ **Authentication is now working!**

</div>
