# ConnectFlavour - Technical Stack Documentation

## Technology Architecture Overview

ConnectFlavour follows a modern **cross-platform mobile application architecture** with a clear separation between frontend, backend, and database layers.

## Frontend Technology Stack

### Flutter Framework

**Version**: Latest (as of project development)
**Language**: Dart

#### Why Flutter?

- **Cross-platform Development** - Single codebase for Android and iOS
- **High Performance** - Natively compiled applications
- **Rich UI Components** - Material Design and Cupertino widgets
- **Hot Reload** - Fast development and debugging
- **Google Support** - Active development and community

#### Flutter Components Used

```yaml
# Key Flutter dependencies (inferred from project description)
dependencies:
  flutter:
    sdk: flutter
  http: ^x.x.x # For API calls
  shared_preferences: ^x.x.x # Local storage
  image_picker: ^x.x.x # Recipe image uploads
  provider: ^x.x.x # State management
  flutter_secure_storage: ^x.x.x # Secure token storage
```

#### Key Flutter Features Implemented

- **Image-based UI Navigation** - Visual recipe categories
- **Responsive Design** - Adaptive layouts for different screen sizes
- **State Management** - Managing user authentication and app state
- **Local Storage** - Caching recipes for offline access
- **Camera Integration** - Recipe photo capture and upload
- **Social Sharing** - Integration with social media platforms

## Backend Technology Stack

### Django Framework

**Version**: Latest LTS (Long Term Support)
**Language**: Python 3.x

#### Why Django?

- **Rapid Development** - "Batteries included" philosophy
- **Security Features** - Built-in protection against common vulnerabilities
- **ORM (Object Relational Mapping)** - Database abstraction layer
- **Admin Interface** - Built-in admin panel for content management
- **REST Framework** - Easy API development
- **Scalability** - Suitable for growing applications

#### Django Components Used

##### Core Framework

```python
# settings.py dependencies
INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'rest_framework',
    'rest_framework.authtoken',
    'corsheaders',
    'recipes',  # Custom app
    'accounts', # Custom app
    'categories', # Custom app
]
```

##### Django REST Framework

- **API Views** - Class-based and function-based views
- **Serializers** - Data validation and serialization
- **Authentication** - Token-based authentication
- **Permissions** - Role-based access control
- **Pagination** - Efficient data loading
- **Filtering** - Recipe search and categorization

#### Backend Architecture Pattern

**Model-View-Template (MVT)** - Django's variation of MVC

##### Models Layer

```python
# Example model structure (inferred from ER diagram)
class Recipe(models.Model):
    recipe_id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=200)
    description = models.TextField()
    image = models.ImageField(upload_to='recipes/')
    category = models.ForeignKey(RecipeCategory, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    popularity = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

class Ingredient(models.Model):
    name = models.CharField(max_length=100)
    unit = models.ForeignKey(Unit, on_delete=models.CASCADE)

class RecipeIngredient(models.Model):
    recipe = models.ForeignKey(Recipe, on_delete=models.CASCADE)
    ingredient = models.ForeignKey(Ingredient, on_delete=models.CASCADE)
    quantity = models.DecimalField(max_digits=10, decimal_places=2)
```

##### API Views Layer

```python
# Example API implementation from the document
class checklistapi(APIView):
    permission_classes = [IsAuthenticated, IsOwner]
    serializers_class = ReceipeItemSerializer

    def get(self, request, format=None):
        category_choice = request.query_params.get('category', None)
        uid_choice = request.query_params.get('id', None)
        user_receipe = request.query_params.get('user', None)
        choice_type = request.query_params.get('usertype', None)

        if category_choice:
            data = Receipe.objects.filter(
                Q(category_id=category_choice) &
                ~Q(receipe_user_id=request.user)
            )
        # Additional filtering logic...

        return Response(serializer.data)
```

## Database Technology Stack

### MySQL Database

**Version**: 8.0+ (recommended)
**Type**: Relational Database Management System (RDBMS)

#### Why MySQL?

- **ACID Compliance** - Data integrity and consistency
- **Performance** - Optimized for read-heavy applications
- **Scalability** - Handles large datasets efficiently
- **Django Integration** - Excellent ORM support
- **Cost-effective** - Open-source with commercial support available
- **Wide Adoption** - Large community and extensive documentation

#### Database Configuration

```python
# Django database settings
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'connectflavour_db',
        'USER': 'your_db_user',
        'PASSWORD': 'your_db_password',
        'HOST': 'localhost',
        'PORT': '3306',
        'OPTIONS': {
            'sql_mode': 'traditional',
        }
    }
}
```

#### Database Features Utilized

- **Foreign Key Relationships** - Maintaining data integrity
- **Indexing** - Optimized search performance
- **Transactions** - Ensuring data consistency
- **Full-text Search** - Recipe and ingredient search functionality
- **JSON Data Types** - Storing complex recipe metadata (MySQL 5.7+)

## Development and Testing Tools

### Postman API Testing

**Purpose**: API Development and Testing Platform

#### Features Used

- **API Documentation** - Interactive API documentation
- **Request Testing** - Manual and automated API testing
- **Environment Variables** - Different configurations for dev/prod
- **Collections** - Organized API endpoint testing
- **Mock Servers** - Frontend development before backend completion

#### Example API Endpoints Tested

```javascript
// Recipe endpoints
GET /api/recipes/
POST /api/recipes/
GET /api/recipes/{id}/
PUT /api/recipes/{id}/
DELETE /api/recipes/{id}/

// Authentication endpoints
POST /api/auth/login/
POST /api/auth/register/
POST /api/auth/logout/

// Category endpoints
GET /api/categories/
GET /api/categories/{id}/recipes/

// Wishlist endpoints
POST /api/wishlist/add/
DELETE /api/wishlist/remove/{id}/
GET /api/wishlist/
```

### Navicat Database Management

**Purpose**: Database Design, Management, and Administration

#### Features Used

- **Visual Database Design** - ER diagram creation and modification
- **SQL Query Builder** - Complex query development and optimization
- **Data Migration** - Import/export data between environments
- **Database Synchronization** - Keeping development and production databases in sync
- **Performance Monitoring** - Query optimization and performance analysis
- **Backup Management** - Database backup and restoration

## Development Environment Setup

### Required Software Stack

```bash
# Frontend Development
- Flutter SDK (3.0+)
- Android Studio / VS Code with Flutter extensions
- Android SDK and emulators
- iOS Simulator (for macOS development)

# Backend Development
- Python 3.8+
- Django 4.x
- MySQL Server 8.0+
- Virtual Environment (venv/conda)

# Development Tools
- Postman (API testing)
- Navicat (Database management)
- Git (Version control)
```

### Development Workflow

1. **Backend API Development** (Django + MySQL)
2. **API Testing** (Postman)
3. **Frontend Development** (Flutter)
4. **Database Management** (Navicat)
5. **Integration Testing** (Full stack)

## Security Considerations

### Authentication & Authorization

- **JWT Tokens** - Stateless authentication
- **Token Expiration** - Security through time-limited access
- **Role-based Permissions** - User and admin role separation
- **Password Hashing** - Django's built-in password security

### Data Security

- **Input Validation** - Protection against injection attacks
- **CORS Configuration** - Cross-origin request security
- **HTTPS Enforcement** - Encrypted data transmission
- **File Upload Security** - Secure image upload handling

## Performance Optimizations

### Backend Optimizations

- **Database Indexing** - Fast recipe and ingredient searches
- **Query Optimization** - Efficient ORM queries
- **Caching Strategy** - Redis for session and data caching
- **Pagination** - Efficient data loading for large recipe collections

### Frontend Optimizations

- **Image Compression** - Optimized recipe image storage
- **Lazy Loading** - Progressive data loading
- **Local Caching** - Offline recipe access
- **Debounced Search** - Efficient search input handling

## Deployment Considerations

### Production Stack Recommendations

```yaml
# Production Environment
Frontend:
  - Flutter Web (Progressive Web App)
  - Mobile App Stores (Google Play, App Store)

Backend:
  - Django + Gunicorn/uWSGI
  - Nginx (Reverse proxy and static files)
  - MySQL (Production database)
  - Redis (Caching layer)

Infrastructure:
  - Cloud hosting (AWS/GCP/Azure)
  - CDN for static assets
  - Load balancing for scalability
  - SSL certificates
```

## Technology Stack Benefits

### Developer Benefits

- **Cross-platform Development** - Reduced development time and cost
- **Rapid Prototyping** - Quick iteration and feature development
- **Strong Community Support** - Extensive documentation and tutorials
- **Modern Development Practices** - Following industry standards

### User Benefits

- **Native Performance** - Smooth app experience
- **Offline Functionality** - Recipe access without internet
- **Fast Loading Times** - Optimized data loading
- **Secure Data Handling** - Protected user information

### Business Benefits

- **Cost-effective Development** - Open-source technologies
- **Scalable Architecture** - Growth-ready infrastructure
- **Maintainable Codebase** - Well-structured and documented code
- **Future-proof Technology** - Modern, actively maintained frameworks

---

_This technical documentation is based on the ConnectFlavour project report and represents the technology stack choices made for the academic implementation._
