# 🔧 Troubleshooting Guide

## Common Issues and Solutions

### Backend Issues

#### ❌ Issue: `python manage.py runserver` fails

**Solution 1: Dependencies not installed**

```bash
cd backend/connectflavour
pip install -r requirements/development.txt
```

**Solution 2: Database not migrated**

```bash
python manage.py migrate
```

**Solution 3: Port already in use**

```bash
# Use a different port
python manage.py runserver 8001
# Then update frontend API URL in lib/config/app_config.dart
```

---

#### ❌ Issue: Database errors when running seed command

**Solution: Clear and reseed**

```bash
# Delete the database file
rm db.sqlite3

# Run migrations again
python manage.py migrate

# Seed data
python manage.py seed_data --clear
```

---

#### ❌ Issue: CORS errors in browser console

**Solution: Check CORS settings**

In `backend/connectflavour/config/settings.py`, ensure:

```python
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://localhost:8080",
    "http://127.0.0.1:3000",
    "http://127.0.0.1:8080",
]
```

---

### Frontend Issues

#### ❌ Issue: `flutter run` fails

**Solution 1: Dependencies not installed**

```bash
cd frontend
flutter pub get
```

**Solution 2: Flutter SDK issues**

```bash
flutter doctor
# Fix any issues shown
```

**Solution 3: No device available**

```bash
# For Windows
flutter run -d windows

# For Web
flutter run -d chrome

# For Android (with emulator)
flutter devices  # List available devices
flutter run -d <device-id>
```

---

#### ❌ Issue: API calls failing / "Connection refused"

**Cause: Backend not running**

**Solution:**

1. Check backend is running on port 8000
2. Open `http://localhost:8000/api/v1/recipes/` in browser
3. If it doesn't load, start backend:
   ```bash
   cd backend/connectflavour
   python manage.py runserver
   ```

---

#### ❌ Issue: "No data showing" in the app

**Solution 1: Database not seeded**

```bash
cd backend/connectflavour
python manage.py seed_data --clear
```

**Solution 2: Check API URL**

In `frontend/lib/config/app_config.dart`, verify:

```dart
static const String baseUrl = 'http://localhost:8000/api/v1';
```

**Solution 3: Check network permissions**

For web, ensure the backend is running and CORS is configured.

---

#### ❌ Issue: Images not uploading

**Solution 1: File size too large**

- Maximum file size is 5MB
- Compress images before uploading

**Solution 2: Check backend media settings**

In `backend/connectflavour/config/settings.py`:

```python
MEDIA_URL = '/media/'
MEDIA_ROOT = BASE_DIR / 'media'
```

Create media folder if it doesn't exist:

```bash
mkdir -p backend/connectflavour/media/recipes/images
```

**Solution 3: Check file permissions**

```bash
# On Linux/Mac
chmod -R 755 backend/connectflavour/media
```

---

### Authentication Issues

#### ❌ Issue: Login fails with "Invalid credentials"

**Solution: Use correct test credentials**

After seeding database:

- **Username:** john_chef, mary_cook, david_baker, etc.
- **Password:** password123

Or create a new account via Register page.

---

#### ❌ Issue: "Token expired" errors

**Solution: Token refresh is automatic**

The `ApiService` automatically refreshes tokens. If it still fails:

1. Logout and login again
2. Clear app storage (for web, clear browser cache)

---

### Development Issues

#### ❌ Issue: Hot reload not working

**Solution: Restart app**

```bash
# In terminal running flutter
r    # Hot reload
R    # Hot restart
```

---

#### ❌ Issue: Code changes not reflecting

**Solution 1: Full restart**

```bash
# Stop the app (Ctrl+C)
flutter run -d windows  # or chrome
```

**Solution 2: Clear build cache**

```bash
flutter clean
flutter pub get
flutter run -d windows
```

---

## Pre-Presentation Checklist

### ✅ Before You Start

1. **Backend Running**

   ```bash
   cd backend/connectflavour
   python manage.py runserver
   ```

   - Should see: "Starting development server at http://127.0.0.1:8000/"

2. **Database Seeded**

   ```bash
   python manage.py seed_data --clear
   ```

   - Should see: "✓ Database seeding completed successfully!"

3. **Frontend Running**

   ```bash
   cd frontend
   flutter run -d windows  # or chrome
   ```

   - App should launch without errors

4. **Test Login**

   - Username: `john_chef`
   - Password: `password123`
   - Should see recipes on home page

5. **Check All Pages Work**
   - [ ] Home page shows recipes
   - [ ] Categories page shows categories
   - [ ] Can click and view recipe details
   - [ ] Can create a new recipe
   - [ ] Can view profile
   - [ ] Can edit profile
   - [ ] Can favorite a recipe
   - [ ] Can add a review

### ✅ Quick Tests

**Test 1: API is working**

```bash
curl http://localhost:8000/api/v1/recipes/
```

Should return JSON with recipes.

**Test 2: Swagger UI accessible**
Open in browser: `http://localhost:8000/api/schema/swagger-ui/`

**Test 3: Django admin accessible**
Open in browser: `http://localhost:8000/admin`
Login with superuser credentials.

---

## Performance Tips

### Making the App Run Faster

1. **Use Release Mode for Demo**

   ```bash
   flutter run --release -d windows
   ```

2. **Optimize Backend**

   ```bash
   # In production, use PostgreSQL instead of SQLite
   # Add database indexes
   # Enable caching
   ```

3. **Clear Old Data**
   ```bash
   # Periodically reseed to remove test clutter
   python manage.py seed_data --clear
   ```

---

## Emergency Recovery

### If Everything Breaks

**Nuclear Option: Start Fresh**

```bash
# Backend
cd backend/connectflavour
rm db.sqlite3
rm -rf media/
python manage.py migrate
python manage.py createsuperuser
python manage.py seed_data --clear

# Frontend
cd frontend
flutter clean
flutter pub get
flutter run -d windows
```

---

## Getting Help

### Useful Commands

**Check Python version:**

```bash
python --version
```

**Check Flutter version:**

```bash
flutter --version
```

**Check running processes:**

```bash
# Windows
netstat -ano | findstr :8000

# Linux/Mac
lsof -i :8000
```

**View Django logs:**

```bash
cd backend/connectflavour/logs
cat django.log  # or tail -f django.log
```

---

## Contact Support

If you're still stuck:

1. Check `VERIFICATION_COMPLETE.md` for detailed documentation
2. Check `QUICKSTART_UPDATED.md` for setup instructions
3. Review error messages carefully
4. Check the terminal/console for error details

---

## Quick Command Reference

### Backend Commands

```bash
python manage.py runserver              # Start server
python manage.py migrate                # Run migrations
python manage.py createsuperuser       # Create admin
python manage.py seed_data --clear     # Seed database
python manage.py shell                 # Django shell
```

### Frontend Commands

```bash
flutter run -d windows                 # Run on Windows
flutter run -d chrome                  # Run on Web
flutter pub get                        # Install dependencies
flutter clean                          # Clean build cache
flutter doctor                         # Check Flutter setup
flutter devices                        # List available devices
```

### Git Commands

```bash
git status                             # Check status
git add .                              # Stage changes
git commit -m "message"                # Commit changes
git push                               # Push to remote
git pull                               # Pull from remote
```

---

**Last Updated:** November 26, 2025  
**Status:** All systems operational ✅
