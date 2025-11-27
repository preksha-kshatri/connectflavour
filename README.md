# 🍳 ConnectFlavour - Recipe Sharing Platform

> **Full-Stack Recipe Discovery & Social Platform**  
> Flutter Frontend • Django REST API Backend • 100% Dynamic & Production-Ready

[![Flutter](https://img.shields.io/badge/Flutter-Latest-blue.svg)](https://flutter.dev/)
[![Django](https://img.shields.io/badge/Django-4.2+-green.svg)](https://www.djangoproject.com/)
[![DRF](https://img.shields.io/badge/DRF-3.14+-red.svg)](https://www.django-rest-framework.org/)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Web%20%7C%20Mobile-orange.svg)]()

---

## 📖 Table of Contents

- [Overview](#-overview)
- [Tech Stack](#-tech-stack)
- [Project Structure](#-project-structure)
- [Features](#-features)
- [Getting Started](#-getting-started)
- [Running the Application](#-running-the-application)
- [Database Seeding](#-database-seeding)
- [API Documentation](#-api-documentation)
- [Architecture](#-architecture)
- [Presentation Guide](#-presentation-guide)

---

## 🎯 Overview

**ConnectFlavour** is a modern, full-stack recipe sharing and discovery platform that enables users to create, share, discover, and favorite recipes. Built with **Flutter** for a beautiful cross-platform UI and **Django REST Framework** for a robust, scalable backend API.

### 🌟 Key Highlights

- ✅ **100% Dynamic UI** - All pages fetch real data from API (zero hardcoded content)
- ✅ **Secure Authentication** - JWT-based auth with automatic token refresh
- ✅ **Image Upload** - Recipe images stored on server with multipart upload
- ✅ **Social Features** - Follow users, favorite recipes, write reviews
- ✅ **Advanced Search** - Filter by category, difficulty, and keywords
- ✅ **Responsive Design** - Professional Material Design 3 UI
- ✅ **Production Ready** - Complete error handling, loading states, empty states
- ✅ **Cross-Platform** - Runs on Windows, Web, Android, iOS

### 📱 Platform Support

| Platform           | Status       | Tested              |
| ------------------ | ------------ | ------------------- |
| 🪟 Windows Desktop | ✅ Supported | ✅ Yes              |
| 🌐 Web Browser     | ✅ Supported | ✅ Yes              |
| 📱 Android Mobile  | ✅ Ready     | ⏳ Deployment Ready |
| 🍎 iOS Mobile      | ✅ Ready     | ⏳ Deployment Ready |

---

## 🛠️ Tech Stack

### Frontend (Flutter)

```yaml
Framework: Flutter SDK (latest stable)
Language: Dart
UI Library: Material Design 3
HTTP Client: Dio (with interceptors, token refresh)
Routing: go_router (declarative routing)
Image Handling: image_picker (multipart upload)
State Management: StatefulWidget + Future/async patterns
Platforms: Windows, Web, Android, iOS
```

**Key Packages:**

- `dio` - Advanced HTTP client with interceptors
- `go_router` - Declarative routing and navigation
- `image_picker` - Cross-platform image selection
- `shared_preferences` - Local storage for tokens

### Backend (Django)

```yaml
Framework: Django 4.2+
REST API: Django REST Framework 3.14+
Database: SQLite (development) / PostgreSQL (production)
Authentication: JWT (djangorestframework-simplejwt)
File Upload: Django File Storage
CORS: django-cors-headers
API Docs: drf-spectacular (OpenAPI 3.0)
```

**Key Packages:**

- `djangorestframework` - RESTful API framework
- `djangorestframework-simplejwt` - JWT authentication
- `django-cors-headers` - CORS handling
- `Pillow` - Image processing

### Database Schema

```
Users → Recipes → Categories
  ↓       ↓         ↓
Reviews  Steps   Difficulty
  ↓       ↓
Ratings  Ingredients
  ↓
Wishlist/Favorites
```

---

## 📁 Project Structure

```
ConnectFlavour/
│
├── 📱 frontend/                           # Flutter Application
│   ├── lib/
│   │   ├── main.dart                     # App entry point
│   │   ├── config/
│   │   │   ├── app_config.dart          # API URL, constants
│   │   │   └── router_config.dart       # Navigation routes
│   │   ├── core/
│   │   │   ├── models/                   # Data models
│   │   │   │   ├── recipe.dart          # Recipe, RecipeStep, Review
│   │   │   │   ├── user.dart            # User, Activity
│   │   │   │   └── category.dart        # Category
│   │   │   └── services/                 # API services
│   │   │       ├── api_service.dart     # Base HTTP client (Dio)
│   │   │       ├── recipe_service.dart  # Recipe CRUD operations
│   │   │       ├── user_service.dart    # User management
│   │   │       └── category_service.dart # Category fetching
│   │   ├── features/                     # Feature modules
│   │   │   ├── recipes/
│   │   │   │   └── presentation/pages/
│   │   │   │       ├── desktop_home_page.dart         # Recipe listing (DYNAMIC)
│   │   │   │       ├── desktop_recipe_detail_page.dart # Recipe details (DYNAMIC)
│   │   │   │       └── desktop_create_recipe_page.dart # Create recipe (DYNAMIC)
│   │   │   ├── categories/
│   │   │   │   └── presentation/pages/
│   │   │   │       └── desktop_categories_page.dart    # Categories (DYNAMIC)
│   │   │   └── accounts/
│   │   │       └── presentation/pages/
│   │   │           ├── desktop_login_page.dart        # Login
│   │   │           ├── desktop_register_page.dart     # Register
│   │   │           └── desktop_profile_page.dart      # Profile (DYNAMIC)
│   │   └── shared/
│   │       └── widgets/                  # Reusable components
│   │           ├── desktop_app_bar.dart
│   │           └── main_navigation.dart
│   ├── assets/                           # Images, icons, fonts
│   ├── pubspec.yaml                      # Flutter dependencies
│   └── analysis_options.yaml            # Linting rules
│
├── 🔧 backend/                            # Django REST API
│   └── connectflavour/
│       ├── manage.py                     # Django CLI
│       ├── config/                       # Project settings
│       │   ├── settings.py              # Django configuration
│       │   ├── urls.py                  # URL routing
│       │   └── wsgi.py                  # WSGI config
│       ├── apps/                         # Django apps
│       │   ├── accounts/                # User authentication
│       │   │   ├── models.py            # User model
│       │   │   ├── serializers.py       # User serializers
│       │   │   └── views.py             # Auth endpoints
│       │   ├── recipes/                 # Recipe management
│       │   │   ├── models.py            # Recipe, Ingredient, Procedure, Rating
│       │   │   ├── serializers.py       # Recipe serializers
│       │   │   └── views.py             # Recipe CRUD endpoints
│       │   ├── categories/              # Categories & difficulty
│       │   │   ├── models.py            # Category, DifficultyLevel, Tag
│       │   │   ├── serializers.py       # Category serializers
│       │   │   └── views.py             # Category endpoints
│       │   ├── social/                  # Social features
│       │   │   ├── models.py            # Wishlist, Follow, Share
│       │   │   └── views.py             # Social endpoints
│       │   └── core/                    # Shared utilities
│       │       ├── models.py            # BaseModel with timestamps
│       │       └── management/commands/
│       │           └── seed_data.py     # Database seeding script
│       ├── requirements/                 # Python dependencies
│       │   ├── base.txt                 # Base requirements
│       │   ├── development.txt          # Dev requirements
│       │   └── production.txt           # Prod requirements
│       ├── db.sqlite3                   # SQLite database (dev)
│       └── logs/                        # Application logs
│
├── 📖 docs/                              # Documentation
│   ├── DESKTOP_APP_STATUS.md            # Desktop migration status
│   ├── features-functionality.md        # Feature specifications
│   ├── system-architecture.md           # Architecture diagrams
│   └── technical-stack.md               # Tech stack details
│
├── README.md                            # This file
├── QUICKSTART_UPDATED.md               # Quick start guide
└── VERIFICATION_COMPLETE.md            # Verification report
```

---

## ✨ Features

### 🔐 Authentication System

- **User Registration** with email validation
- **Secure Login** with JWT token authentication
- **Auto Token Refresh** - Seamless session management
- **Profile Management** - Edit profile, upload avatar
- **Settings** - Change password, manage preferences

### 🍳 Recipe Management

| Feature                 | Description                                    | Status         |
| ----------------------- | ---------------------------------------------- | -------------- |
| **Browse Recipes**      | Grid view with search and filters              | ✅ Implemented |
| **Recipe Details**      | Full recipe with ingredients, steps, nutrition | ✅ Implemented |
| **Create Recipe**       | Form with image upload, dynamic fields         | ✅ Implemented |
| **Edit Recipe**         | Update existing recipes                        | ✅ Implemented |
| **Delete Recipe**       | Remove user's own recipes                      | ✅ Implemented |
| **Favorite/Unfavorite** | Toggle favorite status                         | ✅ Implemented |
| **Rate & Review**       | 5-star rating with written review              | ✅ Implemented |

### 🔍 Search & Discovery

- **Keyword Search** - Search by recipe title
- **Category Filter** - Filter by recipe category (Breakfast, Lunch, Dinner, etc.)
- **Difficulty Filter** - Filter by Easy, Medium, Hard
- **Dynamic Categories** - Browse recipes by category
- **Real-time Results** - Instant filtering as you type

### 👥 Social Features

- **User Profiles** - View recipes, favorites, activity
- **Favorites** - Save recipes to personal collection
- **Reviews** - Read and write recipe reviews
- **Activity Timeline** - Track user cooking journey
- **Recipe Sharing** - Share via social platforms (planned)

### 📊 User Dashboard

- **My Recipes** - All recipes created by user (dynamic from API)
- **Favorites** - All favorited recipes (dynamic from API)
- **Activity** - User activity timeline (dynamic from API)
- **Statistics** - Recipe count, follower count, etc.

---

## 🚀 Getting Started

### Prerequisites

Before running the application, ensure you have:

- **Python 3.8+** installed ([Download](https://www.python.org/downloads/))
- **Flutter SDK** installed ([Download](https://flutter.dev/docs/get-started/install))
- **Git** for version control
- **VS Code** or **Android Studio** (recommended IDEs)

### Installation

#### 1. Clone the Repository

```bash
git clone https://github.com/preksha-kshatri/connectflavour.git
cd connectflavour
```

#### 2. Backend Setup

```bash
# Navigate to backend directory
cd backend/connectflavour

# Install Python dependencies
pip install -r requirements/development.txt

# Run database migrations
python manage.py migrate

# Create superuser (admin account)
python manage.py createsuperuser
# Follow prompts to create admin account

# Seed database with test data
python manage.py seed_data --clear
```

#### 3. Frontend Setup

```bash
# Navigate to frontend directory
cd frontend

# Install Flutter dependencies
flutter pub get

# Verify Flutter installation
flutter doctor
```

---

## 🏃 Running the Application

### Step 1: Start the Backend Server

```bash
cd backend/connectflavour
python manage.py runserver
```

✅ **Backend API running at:** `http://localhost:8000`  
✅ **Admin panel at:** `http://localhost:8000/admin`  
✅ **API docs at:** `http://localhost:8000/api/schema/swagger-ui/`

### Step 2: Start the Frontend

**For Windows Desktop:**

```bash
cd frontend
flutter run -d windows
```

**For Web Browser:**

```bash
cd frontend
flutter run -d chrome
```

**For Android (with emulator running):**

```bash
cd frontend
flutter run -d android
```

### Step 3: Login to the Application

Use one of the seeded test accounts:

| Username    | Email             | Password    |
| ----------- | ----------------- | ----------- |
| john_chef   | john@example.com  | password123 |
| mary_cook   | mary@example.com  | password123 |
| david_baker | david@example.com | password123 |
| sarah_grill | sarah@example.com | password123 |

Or create a new account via the Register page.

---

## 🗄️ Database Seeding

The application includes a comprehensive database seeding script that generates realistic test data.

### Running the Seed Command

```bash
cd backend/connectflavour
python manage.py seed_data --clear
```

### What Gets Created

| Data Type             | Count | Details                                   |
| --------------------- | ----- | ----------------------------------------- |
| **Users**             | 8     | Test users with different specialties     |
| **Categories**        | 15    | Breakfast, Lunch, Dinner, Desserts, etc.  |
| **Difficulty Levels** | 3     | Easy, Medium, Hard                        |
| **Recipes**           | 10    | Complete recipes with ingredients & steps |
| **Reviews**           | 38    | Distributed across all recipes            |
| **Favorites**         | 34    | Random favorites by users                 |

### Sample Recipes Created

1. **Classic Pancakes** (Breakfast, Easy)
2. **Grilled Chicken Salad** (Salads, Easy)
3. **Spaghetti Carbonara** (Pasta, Medium)
4. **Chocolate Chip Cookies** (Desserts, Easy)
5. **Vegetable Stir Fry** (Asian, Easy)
6. **Beef Tacos** (Dinner, Easy)
7. **Tomato Soup** (Soups, Easy)
8. **Grilled Salmon** (Seafood, Medium)
9. **Veggie Burger** (Vegetarian, Medium)
10. **Berry Smoothie** (Beverages, Easy)

---

## 📡 API Documentation

### Base URL

```
http://localhost:8000/api/v1/
```

### Authentication Endpoints

| Method | Endpoint               | Description                     |
| ------ | ---------------------- | ------------------------------- |
| POST   | `/auth/login/`         | User login (returns JWT tokens) |
| POST   | `/auth/register/`      | User registration               |
| POST   | `/auth/logout/`        | User logout                     |
| POST   | `/auth/token/refresh/` | Refresh JWT token               |
| GET    | `/auth/verify/`        | Verify token validity           |

### Recipe Endpoints

| Method | Endpoint                    | Description                     |
| ------ | --------------------------- | ------------------------------- |
| GET    | `/recipes/`                 | List all recipes (with filters) |
| POST   | `/recipes/`                 | Create new recipe               |
| GET    | `/recipes/{slug}/`          | Get recipe by slug              |
| PUT    | `/recipes/{slug}/`          | Update recipe                   |
| DELETE | `/recipes/{slug}/`          | Delete recipe                   |
| POST   | `/recipes/{slug}/favorite/` | Toggle favorite                 |
| GET    | `/recipes/{slug}/reviews/`  | Get recipe reviews              |
| POST   | `/recipes/{slug}/reviews/`  | Add review                      |

### Category Endpoints

| Method | Endpoint              | Description          |
| ------ | --------------------- | -------------------- |
| GET    | `/categories/`        | List all categories  |
| GET    | `/categories/{slug}/` | Get category by slug |

### User Endpoints

| Method | Endpoint                     | Description              |
| ------ | ---------------------------- | ------------------------ |
| GET    | `/users/me/`                 | Get current user profile |
| PUT    | `/users/me/`                 | Update user profile      |
| POST   | `/users/me/avatar/`          | Upload avatar            |
| GET    | `/users/me/recipes/`         | Get user's recipes       |
| GET    | `/users/me/favorites/`       | Get user's favorites     |
| GET    | `/users/me/activity/`        | Get user's activity      |
| POST   | `/users/me/change-password/` | Change password          |

### API Documentation UI

- **Swagger UI:** `http://localhost:8000/api/schema/swagger-ui/`
- **ReDoc:** `http://localhost:8000/api/schema/redoc/`
- **OpenAPI Schema:** `http://localhost:8000/api/schema/`

---

## 🏗️ Architecture

### System Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    CONNECTFLAVOUR ARCHITECTURE               │
├─────────────────────┬─────────────────────┬─────────────────┤
│   Flutter Frontend  │   Django REST API   │   SQLite/MySQL  │
│    (Client-Side)    │    (Server-Side)    │   (Database)    │
├─────────────────────┼─────────────────────┼─────────────────┤
│                     │                     │                 │
│ • Material 3 UI     │ • JWT Auth          │ • User Data     │
│ • Dio HTTP Client   │ • Recipe CRUD       │ • Recipe Data   │
│ • State Management  │ • File Upload       │ • Media Files   │
│ • Image Picker      │ • Search & Filter   │ • Relationships │
│ • Local Storage     │ • Social Features   │ • Indexes       │
│ • Navigation        │ • CORS Headers      │ • Constraints   │
│                     │                     │                 │
└─────────────────────┴─────────────────────┴─────────────────┘
```

### Data Flow

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│    User      │────────▶│   Flutter    │────────▶│   Django     │
│  Interface   │  Action │     App      │  HTTP   │   REST API   │
└──────────────┘         └──────────────┘         └──────────────┘
                                │                         │
                                │                         │
                                ▼                         ▼
                         ┌──────────────┐         ┌──────────────┐
                         │  Local       │         │   Database   │
                         │  Storage     │         │   (SQLite)   │
                         └──────────────┘         └──────────────┘
```

### Frontend Architecture

```
lib/
├── main.dart                    # Entry point
├── config/                      # Configuration
│   ├── app_config.dart         # API URLs, constants
│   └── router_config.dart      # Navigation routes
├── core/                        # Core functionality
│   ├── models/                 # Data models
│   └── services/               # API services
├── features/                    # Feature modules
│   ├── recipes/                # Recipe feature
│   ├── categories/             # Category feature
│   └── accounts/               # Auth feature
└── shared/                      # Shared widgets
    └── widgets/                # Reusable components
```

### Backend Architecture

```
apps/
├── accounts/                    # User management
│   ├── models.py               # User model
│   ├── serializers.py          # User serializers
│   └── views.py                # Auth endpoints
├── recipes/                     # Recipe management
│   ├── models.py               # Recipe, Procedure, Rating
│   ├── serializers.py          # Recipe serializers
│   └── views.py                # Recipe endpoints
├── categories/                  # Categories
│   ├── models.py               # Category, Difficulty, Tag
│   └── views.py                # Category endpoints
└── social/                      # Social features
    ├── models.py               # Wishlist, Follow
    └── views.py                # Social endpoints
```

---

## 🎤 Presentation Guide

### For Presenting This System

#### 1. Introduction (2 minutes)

**What to say:**

> "ConnectFlavour is a full-stack recipe sharing platform built with Flutter and Django. It allows users to discover, create, share, and favorite recipes. The key highlight is that it's 100% dynamic - every piece of data you see comes from the API, with proper loading states and error handling."

**What to show:**

- Open the app and show the home page loading
- Highlight the professional UI design
- Show the sidebar navigation

#### 2. Tech Stack (3 minutes)

**What to say:**

> "The frontend is built with Flutter using Material Design 3, which gives us cross-platform support - the same codebase runs on Windows, Web, Android, and iOS. The backend is Django REST Framework, providing a robust RESTful API with JWT authentication."

**What to show:**

- Open VS Code and show the project structure
- Show `frontend/lib` folder structure
- Show `backend/connectflavour/apps` folder structure
- Highlight the separation of concerns

#### 3. Key Features (5 minutes)

**What to say:**

> "Let me walk you through the main features:"

**Demo flow:**

1. **Home Page** - "This displays all recipes from the database with search and filters"

   - Show search functionality
   - Show category filter
   - Show difficulty filter
   - Click on a recipe card

2. **Recipe Detail** - "Here we see the full recipe with ingredients, instructions, and reviews"

   - Show the breadcrumb navigation
   - Show the tabs (Ingredients, Instructions, Nutrition, Reviews)
   - Show the favorite button
   - Show reviews with ratings

3. **Create Recipe** - "Users can create new recipes with image upload"

   - Click "Create Recipe"
   - Show the form with dynamic ingredient/instruction fields
   - Show the image picker
   - Demonstrate adding/removing fields

4. **Categories** - "Browse recipes by category"

   - Navigate to Categories page
   - Show the grid of categories
   - Show recipe counts
   - Click a category

5. **Profile** - "User profiles with dynamic tabs"
   - Navigate to Profile
   - Show "My Recipes" tab
   - Show "Favorites" tab
   - Show "Activity" tab
   - Click edit profile button
   - Show settings dialog

#### 4. Technical Implementation (5 minutes)

**What to say:**

> "Let me show you how the API integration works:"

**What to show:**

1. Open `api_service.dart` - "This is our base HTTP client using Dio with JWT token management"
2. Open `recipe_service.dart` - "This handles all recipe-related API calls"
3. Open `desktop_home_page.dart` - "See how we fetch data and handle loading states"
4. Show the network tab in browser dev tools making API calls

**Backend demo:**

1. Open `http://localhost:8000/api/schema/swagger-ui/` - "Interactive API documentation"
2. Show the `/recipes/` endpoint
3. Show the response structure
4. Open Django admin at `http://localhost:8000/admin`
5. Show the database models

#### 5. Database & Seeding (2 minutes)

**What to say:**

> "We have a comprehensive database seeding script that generates realistic test data."

**What to show:**

```bash
python manage.py seed_data --clear
```

- Show the console output
- Refresh the app to show new data
- Open Django admin to show the created data

#### 6. Code Quality (2 minutes)

**What to say:**

> "The codebase follows best practices with proper error handling, loading states, and clean architecture."

**What to show:**

1. Show loading state - refresh a page
2. Show error handling - stop backend server and show error message
3. Show empty state - login as new user with no recipes
4. Show the folder structure following clean architecture

#### 7. Q&A Preparation

**Common Questions:**

**Q: Is it production-ready?**

> "Yes, it has proper error handling, authentication, image upload, and can be deployed to any hosting platform."

**Q: Can it scale?**

> "Yes, Django REST Framework is highly scalable. We use proper database indexing, pagination, and can add caching with Redis."

**Q: How do you handle authentication?**

> "We use JWT tokens with automatic refresh. The tokens are stored securely and attached to every API request via Dio interceptors."

**Q: Can you add more features?**

> "Absolutely. The architecture is modular, so we can easily add features like meal planning, shopping lists, recipe collections, etc."

**Q: How long did it take to build?**

> "The initial mobile version was an academic project. The desktop migration and making everything dynamic took additional development time."

### Tips for Presentation

✅ **Do:**

- Start with the app running and showing data
- Have backend server running before presenting
- Use the seed command to generate fresh data
- Show both the UI and code side-by-side
- Demonstrate error handling by stopping the backend
- Show the API documentation in Swagger UI
- Highlight the professional UI/UX design
- Mention cross-platform capability

❌ **Don't:**

- Don't start with a blank database
- Don't forget to seed data before presenting
- Don't skip showing error states
- Don't forget to mention JWT authentication
- Don't skip the API documentation
- Don't present without testing first

### Demo Script Checklist

- [ ] Backend server running on port 8000
- [ ] Database seeded with test data
- [ ] Frontend running on Windows/Web
- [ ] Logged in with a test account
- [ ] Swagger UI tab open in browser
- [ ] VS Code open with project
- [ ] All features working (test before presenting)

---

## 📞 Support & Contact

For questions or issues:

- **GitHub:** [preksha-kshatri/connectflavour](https://github.com/preksha-kshatri/connectflavour)
- **Documentation:** See `docs/` folder for detailed documentation
- **Quick Start:** See `QUICKSTART_UPDATED.md`
- **Verification:** See `VERIFICATION_COMPLETE.md`

---

## 📄 License

This project is developed as part of an academic project and is available for educational purposes.

---

<div align="center">

**Built with ❤️ using Flutter & Django**

⭐ **Star this repo if you find it useful!**

</div>
