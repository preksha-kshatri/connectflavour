# ConnectFlavour Recipe API Backend

Django REST API backend for the ConnectFlavour Recipe mobile application.

## Project Structure

```
backend/
├── connectflavour/          # Main Django project
│   ├── apps/               # Django applications
│   │   ├── accounts/       # User authentication & profiles
│   │   ├── recipes/        # Recipe management
│   │   ├── categories/     # Recipe categories
│   │   └── social/         # Social features (wishlist, following)
│   ├── config/             # Project configuration
│   ├── core/              # Core utilities and base classes
│   └── media/             # User uploaded files
├── requirements/           # Python dependencies
└── docker/                # Docker configuration
```

## Setup Instructions

### Prerequisites

- Python 3.11+
- PostgreSQL 14+
- Redis 7+

### Installation

1. Create virtual environment:

```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:

```bash
pip install -r requirements/development.txt
```

3. Setup environment variables:

```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Run migrations:

```bash
python manage.py migrate
```

5. Create superuser:

```bash
python manage.py createsuperuser
```

6. Start development server:

```bash
python manage.py runserver
```

## API Documentation

API documentation available at `/api/docs/` when running the server.

## Testing

Run tests with:

```bash
python manage.py test
```

## Features

- User authentication (JWT)
- Recipe CRUD operations
- Recipe search and filtering
- Recommendation algorithms
- Social features (wishlist, following)
- Admin dashboard
- Image upload and processing
- Email notifications
