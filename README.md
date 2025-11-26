# 🍳 ConnectFlavour Recipe App - Cross-Platform Application

> **Full-Stack Recipe Sharing Platform - Now on Desktop!**  
> _Mobile, Desktop & Web - One Codebase, Six Platforms_

[![Flutter](https://img.shields.io/badge/Flutter-3.35.4-blue.svg)](https://flutter.dev/)
[![Django](https://img.shields.io/badge/Django-4.2.7-green.svg)](https://www.djangoproject.com/)
[![Platforms](https://img.shields.io/badge/Platforms-6-orange.svg)](QUICKSTART.md)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## 🚀 **NEW: Desktop Application Support!**

ConnectFlavour now runs on **6 platforms**:

- 🖥️ **macOS** (Desktop) - NEW!
- 🪟 **Windows** (Desktop) - NEW!
- � **Linux** (Desktop) - NEW!
- 📱 **Android** (Mobile)
- 🍎 **iOS** (Mobile)
- 🌐 **Web** (Browser)

**Quick Start**: See [QUICKSTART.md](QUICKSTART.md) for installation guide  
**Status Report**: See [docs/DESKTOP_APP_STATUS.md](docs/DESKTOP_APP_STATUS.md) for complete details

## �📋 Project Overview

ConnectFlavour is a comprehensive recipe sharing and discovery application with a robust backend API. Originally developed as an academic project, it has been transformed into a production-ready, **cross-platform application** supporting mobile, desktop, and web.

### 🎯 Key Features

- ✅ **User Authentication** - JWT-based secure login/register with email verification
- ✅ **Recipe Management** - Complete CRUD operations with image uploads
- ✅ **Advanced Search** - Multi-filter search with ingredient-based discovery
- ✅ **Social Features** - Follow users, wishlist recipes, share content
- ✅ **Category System** - Organized recipe browsing and filtering
- ✅ **Rating System** - User reviews and popularity algorithms
- ✅ **Responsive Design** - Beautiful Material 3 Flutter interface
- ✅ **Admin Dashboard** - Content management and user administration
- ✅ **API Documentation** - Complete OpenAPI/Swagger docs

### 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    CONNECTFLAVOUR ARCHITECTURE               │
├─────────────────────┬─────────────────────┬─────────────────┤
│   Flutter Mobile    │    Django REST      │   PostgreSQL    │
│   (Frontend)        │    API (Backend)    │   (Database)    │
│                     │                     │                 │
│ • Material 3 UI     │ • JWT Auth          │ • User Data     │
│ • State Management  │ • Recipe CRUD       │ • Recipe Data   │
│ • Local Storage     │ • Search & Filter   │ • Media Files   │
│ • Image Caching     │ • Social Features   │ • Analytics     │
│ • Offline Support   │ • Admin Interface   │ • Backups       │
└─────────────────────┴─────────────────────┴─────────────────┘
```

### Core Features Implemented

- ✅ **User Authentication** - Secure registration and login system
- ✅ **Recipe Management** - Full CRUD operations for recipes
- ✅ **Category System** - Organized recipe categorization
- ✅ **Search & Discovery** - Advanced recipe search functionality
- ✅ **Wishlist/Favorites** - Personal recipe collection management
- ✅ **Social Features** - Recipe sharing and user following
- ✅ **Admin Dashboard** - Content and user management tools

### Technology Architecture

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Flutter App   │    │  Django REST    │    │ MySQL Database │
│   (Frontend)    │◄──►│   API Server    │◄──►│   (Backend)     │
│                 │    │   (Backend)     │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘
        │                       │                       │
        │                       │                       │
     Mobile UI              Business Logic         Data Storage
   Image-based UI        Authentication APIs    Relational Schema
   State Management      Recipe Management      Normalized Design
   Local Caching        Search & Discovery     Performance Indexes
```

## 🚀 Quick Start

### Backend Setup

1. **Clone and Setup**

```bash
cd backend/connectflavour
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements/development.txt
```

2. **Database Setup**

```bash
cp .env.example .env
# Edit .env with your database credentials
python manage.py migrate
python manage.py createsuperuser
```

3. **Run Development Server**

```bash
python manage.py runserver
```

### Frontend Setup

1. **Flutter Dependencies**

```bash
cd frontend
flutter pub get
```

2. **Configure API Endpoint**

```dart
// lib/config/app_config.dart
static const String baseUrl = 'http://localhost:8000/api/v1';
```

3. **Run Flutter App**

```bash
flutter run
```

## 📁 Project Structure

```
ConnectFlavour/
├── 📖 docs/                          # Complete project documentation
│   ├── project-analysis.md           # Academic project analysis
│   ├── system-architecture.md        # Technical architecture & ER diagrams
│   ├── features-functionality.md     # Detailed feature specifications
│   ├── technical-stack.md           # Technology choices & setup
│   ├── testing-strategy.md          # Testing methodology & cases
│   └── implementation-roadmap.md    # Production deployment plan
│
├── 🔧 backend/                       # Django REST API Backend
│   └── connectflavour/
│       ├── config/                   # Django project configuration
│       ├── apps/
│       │   ├── accounts/            # User authentication & profiles
│       │   ├── recipes/             # Recipe management & discovery
│       │   ├── categories/          # Recipe categorization
│       │   ├── social/              # Social features & interactions
│       │   └── core/                # Shared utilities & base classes
│       └── requirements/            # Python dependencies
│
├── 📱 frontend/                      # Flutter Mobile Application
│   └── lib/
│       ├── config/                   # App configuration & routing
│       ├── core/                     # Core services & theme
│       ├── features/                 # Feature-based architecture
│       │   ├── authentication/       # Login/Register flows
│       │   ├── recipes/             # Recipe browsing & creation
│       │   ├── categories/          # Category navigation
│       │   ├── social/              # Social interactions
│       │   └── profile/             # User profile management
│       └── shared/                  # Reusable components & widgets
│
└── 📋 README.md                     # This file
```

## 🛠️ Technology Stack

### Backend Technologies

- **Framework**: Django 4.2 + Django REST Framework
- **Database**: PostgreSQL 14+ with optimized indexing
- **Authentication**: JWT tokens with refresh mechanism
- **File Storage**: Local media + AWS S3 support
- **Caching**: Redis for session & API caching
- **Documentation**: OpenAPI 3.0 (Swagger/ReDoc)
- **Testing**: Pytest with factory-boy fixtures

### Frontend Technologies

- **Framework**: Flutter 3.10+ with Material 3 design
- **State Management**: Riverpod for reactive state
- **HTTP Client**: Dio with retry & caching logic
- **Local Storage**: Hive + SharedPreferences
- **Navigation**: GoRouter with deep linking
- **Image Handling**: cached_network_image with optimization
- **Architecture**: Clean Architecture + Feature-first

### Development Tools

- **API Documentation**: http://localhost:8000/api/docs/
- **Code Quality**: Black, isort, flake8 (Python) + flutter_lints
- **Version Control**: Git with conventional commits
- **Environment**: Docker support for easy deployment

## 🌟 Key Features Implemented

### 🔐 Authentication System

- **Secure Registration** with email verification
- **JWT-based Login** with token refresh
- **Password Reset** functionality
- **Social Login** (Google/Facebook ready)
- **Profile Management** with avatar uploads

### 🍳 Recipe Management

- **Rich Recipe Editor** with step-by-step instructions
- **Image Uploads** with automatic compression
- **Ingredient Management** with auto-complete
- **Category & Tag System** for organization
- **Difficulty Levels** and time estimates
- **Nutritional Information** tracking

### � Search & Discovery

- **Advanced Filtering** by category, difficulty, time, ingredients
- **Full-text Search** across titles, descriptions, ingredients
- **Popularity-based Recommendations** using engagement metrics
- **Collaborative Filtering** for personalized suggestions
- **Trending Recipes** with time-decay algorithms
- **Seasonal Recommendations** based on user location

### 👥 Social Features

- **User Following System** with activity feeds
- **Recipe Wishlist/Favorites** with personal collections
- **Recipe Sharing** across social platforms
- **Comments & Reviews** with threading support
- **User Profiles** with cooking statistics
- **Recipe Collections** for organizing favorites

### 📊 Analytics & Admin

- **User Engagement Tracking** for recommendation algorithms
- **Recipe Performance Metrics** (views, saves, shares)
- **Admin Dashboard** for content moderation
- **User Management** with role-based permissions
- **Content Analytics** for trending identification
- **System Health Monitoring** with error tracking

## 🎨 UI/UX Design

### Design System

- **Material 3** design language with custom color palette
- **Responsive Layout** supporting various screen sizes
- **Dark/Light Mode** with system preference detection
- **Accessibility** features with semantic labels
- **Smooth Animations** using Flutter's animation framework
- **Custom Icons** and illustrations for brand identity

### User Experience

- **Intuitive Navigation** with bottom tab bar
- **Smart Search** with auto-suggestions and filters
- **Offline Support** for saved recipes and user data
- **Fast Loading** with image caching and lazy loading
- **Error Handling** with user-friendly messages
- **Progressive Enhancement** for various network conditions

## 📈 Performance & Scalability

### Backend Optimizations

- **Database Indexing** for common query patterns
- **Query Optimization** with select_related and prefetch_related
- **Caching Strategy** using Redis for frequently accessed data
- **Pagination** for large dataset handling
- **Background Tasks** with Celery for email sending
- **Media Optimization** with automatic image resizing

### Frontend Optimizations

- **Lazy Loading** for recipe lists and images
- **State Management** with efficient widget rebuilds
- **Local Caching** for user preferences and offline data
- **Image Optimization** with multiple resolution support
- **Bundle Optimization** with code splitting strategies
- **Memory Management** with proper widget disposal

## 🧪 Testing Strategy

### Backend Testing

- **Unit Tests** for models, serializers, and utilities
- **Integration Tests** for API endpoints and workflows
- **Authentication Tests** for security validation
- **Performance Tests** for database query optimization
- **API Documentation Tests** ensuring accuracy

### Frontend Testing

- **Widget Tests** for individual component behavior
- **Integration Tests** for user flow validation
- **Golden Tests** for UI consistency across devices
- **Performance Tests** for animation smoothness
- **Accessibility Tests** for inclusive design

## 🚀 Deployment & DevOps

### Production Deployment

- **Docker Containerization** for consistent environments
- **Environment Configuration** with secure secret management
- **Database Migrations** with zero-downtime strategies
- **Static File Serving** via CDN integration
- **Error Monitoring** with Sentry integration
- **Backup Strategy** for data protection

### CI/CD Pipeline

- **Automated Testing** on pull requests
- **Code Quality Checks** with linting and formatting
- **Security Scanning** for dependency vulnerabilities
- **Automated Deployments** with staging environments
- **Performance Monitoring** with alerting
- **Documentation Updates** with automated generation

## � API Documentation

### Authentication Endpoints

```bash
POST /api/v1/auth/register/          # User registration
POST /api/v1/auth/login/             # User login
POST /api/v1/auth/logout/            # User logout
POST /api/v1/auth/token/refresh/     # Refresh JWT token
GET  /api/v1/auth/profile/           # Get user profile
PUT  /api/v1/auth/profile/           # Update user profile
```

### Recipe Management Endpoints

```bash
GET    /api/v1/recipes/              # List recipes (with filters)
POST   /api/v1/recipes/              # Create new recipe
GET    /api/v1/recipes/{slug}/       # Get recipe details
PUT    /api/v1/recipes/{slug}/       # Update recipe
DELETE /api/v1/recipes/{slug}/       # Delete recipe
POST   /api/v1/recipes/{slug}/rate/  # Rate recipe
```

### Social Feature Endpoints

```bash
POST /api/v1/social/follow/{username}/     # Follow user
POST /api/v1/social/wishlist/              # Manage wishlist
GET  /api/v1/social/users/{user}/followers/ # Get followers
POST /api/v1/recipes/{slug}/share/         # Share recipe
```

**Complete API Documentation**: http://localhost:8000/api/docs/

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes with tests
4. Commit your changes (`git commit -m 'Add amazing feature'`)
5. Push to the branch (`git push origin feature/amazing-feature`)
6. Open a Pull Request

### Code Standards

- **Backend**: Follow PEP 8 with Black formatting
- **Frontend**: Follow Dart/Flutter conventions with flutter_lints
- **Testing**: Maintain >80% code coverage
- **Documentation**: Update relevant docs with changes

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Original Academic Project**: Shraddha Maharjan & Bina Tamang (Tribhuvan University)
- **Supervisor**: Kamal Tamrakar
- **Institution**: Janamaitri Multiple Campus, Nepal
- **Flutter Team**: For the amazing cross-platform framework
- **Django Team**: For the robust web framework
- **Open Source Community**: For the incredible tools and libraries

---

## 📞 Support & Contact

- **Issues**: [GitHub Issues](https://github.com/username/connectflavour/issues)
- **Documentation**: [Project Wiki](https://github.com/username/connectflavour/wiki)
- **Discussions**: [GitHub Discussions](https://github.com/username/connectflavour/discussions)

---

<div align="center">

**Built with ❤️ using Flutter & Django**

[⭐ Star this repo](https://github.com/username/connectflavour) • [🍽️ Try the Demo](https://demo.connectflavour.com) • [📖 Read the Docs](https://docs.connectflavour.com)

</div>
