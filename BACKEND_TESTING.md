# 🧪 Backend API Testing Guide

Your Django backend is running at **http://127.0.0.1:8000/** - here's how to test it!

## 🎯 **Quick Tests You Can Do Right Now**

### **1. Admin Panel Access** ✅

- **URL**: http://127.0.0.1:8000/admin/
- **Username**: `admin`
- **Password**: `admin123`
- **What you can do**: Create users, recipes, categories, manage all data

### **2. API Documentation** 📚

- **URL**: http://127.0.0.1:8000/api/docs/
- **What you'll see**: Interactive API documentation (Swagger/OpenAPI)
- **Features**: Test all endpoints directly from the browser

### **3. Basic API Endpoints** 🔗

#### **Authentication Endpoints**:

```bash
# Register new user
curl -X POST http://127.0.0.1:8000/api/v1/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","email":"test@example.com","password":"testpass123"}'

# Login user
curl -X POST http://127.0.0.1:8000/api/v1/auth/login/ \
  -H "Content-Type: application/json" \
  -d '{"username":"testuser","password":"testpass123"}'
```

#### **Recipe Endpoints**:

```bash
# Get all recipes
curl http://127.0.0.1:8000/api/v1/recipes/

# Get categories
curl http://127.0.0.1:8000/api/v1/categories/
```

### **4. Browser Testing** 🌐

Just open these URLs in your browser:

- **API Root**: http://127.0.0.1:8000/api/v1/
- **Recipes**: http://127.0.0.1:8000/api/v1/recipes/
- **Categories**: http://127.0.0.1:8000/api/v1/categories/
- **Admin**: http://127.0.0.1:8000/admin/

## 🚀 **What's Already Working**

✅ **User Authentication**: Register, login, JWT tokens  
✅ **Recipe Management**: Create, read, update, delete recipes  
✅ **Categories**: Recipe categorization system  
✅ **Social Features**: Following, wishlist, collections  
✅ **Admin Interface**: Full content management  
✅ **API Documentation**: Interactive Swagger docs

## 📱 **Once Flutter is Setup**

After you configure Flutter PATH (see FLUTTER_SETUP.md):

```bash
cd frontend
flutter pub get     # Install dependencies
flutter run         # Start the mobile app
```

The Flutter app will automatically connect to your running Django backend! 🔄

---

**Your ConnectFlavour backend is fully operational! 🎉**
