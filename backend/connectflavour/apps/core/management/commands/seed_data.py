"""
Django management command to seed the database with dummy data for testing.
"""
from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from django.utils.text import slugify
from datetime import datetime, timedelta
import random

from apps.categories.models import Category, DifficultyLevel
from apps.recipes.models import Recipe, RecipeProcedure, RecipeRating
from apps.social.models import Wishlist

User = get_user_model()


class Command(BaseCommand):
    help = 'Seeds the database with dummy data for testing'

    def add_arguments(self, parser):
        parser.add_argument(
            '--clear',
            action='store_true',
            help='Clear existing data before seeding',
        )

    def handle(self, *args, **options):
        if options['clear']:
            self.stdout.write('Clearing existing data...')
            RecipeRating.objects.all().delete()
            Wishlist.objects.all().delete()
            RecipeProcedure.objects.all().delete()
            Recipe.objects.all().delete()
            Category.objects.all().delete()
            User.objects.filter(is_superuser=False).delete()
            self.stdout.write(self.style.SUCCESS('✓ Cleared existing data'))

        self.stdout.write('Seeding database...')

        # Create users
        users = self.create_users()
        self.stdout.write(self.style.SUCCESS(f'✓ Created {len(users)} users'))

        # Create categories
        categories = self.create_categories()
        self.stdout.write(self.style.SUCCESS(
            f'✓ Created {len(categories)} categories'))

        # Create difficulty levels
        difficulty_levels = self.create_difficulty_levels()
        self.stdout.write(self.style.SUCCESS(
            f'✓ Created {len(difficulty_levels)} difficulty levels'))

        # Create recipes
        recipes = self.create_recipes(users, categories, difficulty_levels)
        self.stdout.write(self.style.SUCCESS(
            f'✓ Created {len(recipes)} recipes'))

        # Create reviews
        reviews = self.create_reviews(users, recipes)
        self.stdout.write(self.style.SUCCESS(
            f'✓ Created {len(reviews)} reviews'))

        # Create favorites
        favorites = self.create_favorites(users, recipes)
        self.stdout.write(self.style.SUCCESS(
            f'✓ Created {len(favorites)} favorites'))

        self.stdout.write(self.style.SUCCESS(
            '\n✓ Database seeding completed successfully!'))

    def create_users(self):
        """Create dummy users"""
        users = []
        user_data = [
            {'username': 'john_chef', 'email': 'john@example.com',
                'first_name': 'John', 'last_name': 'Chef'},
            {'username': 'mary_cook', 'email': 'mary@example.com',
                'first_name': 'Mary', 'last_name': 'Cook'},
            {'username': 'david_baker', 'email': 'david@example.com',
                'first_name': 'David', 'last_name': 'Baker'},
            {'username': 'sarah_grill', 'email': 'sarah@example.com',
                'first_name': 'Sarah', 'last_name': 'Grill'},
            {'username': 'mike_pasta', 'email': 'mike@example.com',
                'first_name': 'Mike', 'last_name': 'Pasta'},
            {'username': 'lisa_vegan', 'email': 'lisa@example.com',
                'first_name': 'Lisa', 'last_name': 'Green'},
            {'username': 'tom_asian', 'email': 'tom@example.com',
                'first_name': 'Tom', 'last_name': 'Wang'},
            {'username': 'emma_dessert', 'email': 'emma@example.com',
                'first_name': 'Emma', 'last_name': 'Sweet'},
        ]

        for data in user_data:
            user, created = User.objects.get_or_create(
                username=data['username'],
                defaults={
                    'email': data['email'],
                    'first_name': data['first_name'],
                    'last_name': data['last_name'],
                }
            )
            if created:
                user.set_password('password123')
                user.save()
            users.append(user)

        return users

    def create_categories(self):
        """Create recipe categories"""
        categories_data = [
            {'name': 'Breakfast', 'description': 'Start your day right'},
            {'name': 'Lunch', 'description': 'Perfect midday meals'},
            {'name': 'Dinner', 'description': 'Evening delights'},
            {'name': 'Desserts', 'description': 'Sweet treats'},
            {'name': 'Appetizers', 'description': 'Small bites'},
            {'name': 'Salads', 'description': 'Fresh and healthy'},
            {'name': 'Soups', 'description': 'Warm comfort food'},
            {'name': 'Beverages', 'description': 'Drinks and smoothies'},
            {'name': 'Pasta', 'description': 'Italian classics'},
            {'name': 'Seafood', 'description': 'From the ocean'},
            {'name': 'Vegetarian', 'description': 'Meat-free dishes'},
            {'name': 'Vegan', 'description': 'Plant-based recipes'},
            {'name': 'Grill', 'description': 'BBQ and grilled'},
            {'name': 'Baking', 'description': 'Breads and pastries'},
            {'name': 'Asian', 'description': 'Oriental cuisine'},
        ]

        categories = []
        for data in categories_data:
            category, _ = Category.objects.get_or_create(
                name=data['name'],
                defaults={
                    'slug': slugify(data['name']),
                    'description': data['description'],
                }
            )
            categories.append(category)

        return categories

    def create_difficulty_levels(self):
        """Create difficulty levels"""
        levels_data = [
            {'name': 'easy', 'description': 'Simple recipes for beginners'},
            {'name': 'medium', 'description': 'Intermediate cooking skills required'},
            {'name': 'hard', 'description': 'Advanced techniques needed'},
        ]

        levels = []
        for data in levels_data:
            level, _ = DifficultyLevel.objects.get_or_create(
                name=data['name'],
                defaults={'description': data['description']}
            )
            levels.append(level)

        return levels

    def create_recipes(self, users, categories, difficulty_levels):
        """Create dummy recipes"""
        recipes_data = [
            {
                'title': 'Classic Pancakes',
                'category': 'Breakfast',
                'difficulty': 'Easy',
                'prep_time': 10,
                'cook_time': 15,
                'servings': 4,
                'description': 'Fluffy and delicious breakfast pancakes',
                'ingredients': ['2 cups flour', '2 eggs', '1.5 cups milk', '2 tbsp sugar', '2 tsp baking powder', 'Pinch of salt'],
                'instructions': [
                    'Mix dry ingredients in a bowl',
                    'Whisk wet ingredients separately',
                    'Combine wet and dry ingredients',
                    'Heat pan and pour batter',
                    'Cook until bubbles form, then flip',
                ],
            },
            {
                'title': 'Grilled Chicken Salad',
                'category': 'Salads',
                'difficulty': 'Easy',
                'prep_time': 15,
                'cook_time': 20,
                'servings': 2,
                'description': 'Healthy grilled chicken on fresh greens',
                'ingredients': ['2 chicken breasts', 'Mixed greens', 'Cherry tomatoes', 'Cucumber', 'Olive oil', 'Lemon', 'Salt and pepper'],
                'instructions': [
                    'Season chicken with salt and pepper',
                    'Grill chicken until cooked through',
                    'Chop vegetables',
                    'Arrange greens on plate',
                    'Slice chicken and place on salad',
                    'Drizzle with olive oil and lemon',
                ],
            },
            {
                'title': 'Spaghetti Carbonara',
                'category': 'Pasta',
                'difficulty': 'Medium',
                'prep_time': 10,
                'cook_time': 20,
                'servings': 4,
                'description': 'Classic Italian pasta with creamy sauce',
                'ingredients': ['400g spaghetti', '200g pancetta', '4 eggs', '100g parmesan', 'Black pepper', 'Salt'],
                'instructions': [
                    'Cook spaghetti in salted water',
                    'Fry pancetta until crispy',
                    'Beat eggs with parmesan',
                    'Drain pasta, reserve pasta water',
                    'Mix hot pasta with pancetta',
                    'Remove from heat, add egg mixture',
                    'Add pasta water if needed',
                    'Serve with extra parmesan',
                ],
            },
            {
                'title': 'Chocolate Chip Cookies',
                'category': 'Desserts',
                'difficulty': 'Easy',
                'prep_time': 15,
                'cook_time': 12,
                'servings': 24,
                'description': 'Soft and chewy chocolate chip cookies',
                'ingredients': ['2 cups flour', '1 cup butter', '1 cup sugar', '1 cup brown sugar', '2 eggs', '2 cups chocolate chips', '1 tsp vanilla', '1 tsp baking soda', 'Pinch of salt'],
                'instructions': [
                    'Cream butter and sugars',
                    'Add eggs and vanilla',
                    'Mix in dry ingredients',
                    'Fold in chocolate chips',
                    'Drop spoonfuls on baking sheet',
                    'Bake at 375°F for 10-12 minutes',
                ],
            },
            {
                'title': 'Vegetable Stir Fry',
                'category': 'Asian',
                'difficulty': 'Easy',
                'prep_time': 15,
                'cook_time': 10,
                'servings': 4,
                'description': 'Quick and healthy Asian-style vegetables',
                'ingredients': ['Mixed vegetables', 'Soy sauce', 'Garlic', 'Ginger', 'Sesame oil', 'Cornstarch', 'Rice'],
                'instructions': [
                    'Prep all vegetables',
                    'Heat wok or large pan',
                    'Add oil and aromatics',
                    'Stir fry vegetables',
                    'Add sauce',
                    'Serve over rice',
                ],
            },
            {
                'title': 'Beef Tacos',
                'category': 'Dinner',
                'difficulty': 'Easy',
                'prep_time': 10,
                'cook_time': 15,
                'servings': 4,
                'description': 'Delicious Mexican-style beef tacos',
                'ingredients': ['500g ground beef', 'Taco shells', 'Lettuce', 'Tomatoes', 'Cheese', 'Sour cream', 'Taco seasoning'],
                'instructions': [
                    'Brown ground beef',
                    'Add taco seasoning and water',
                    'Simmer until thickened',
                    'Warm taco shells',
                    'Chop vegetables',
                    'Assemble tacos with toppings',
                ],
            },
            {
                'title': 'Tomato Soup',
                'category': 'Soups',
                'difficulty': 'Easy',
                'prep_time': 10,
                'cook_time': 25,
                'servings': 6,
                'description': 'Creamy homemade tomato soup',
                'ingredients': ['2 cans tomatoes', '1 onion', '2 cloves garlic', 'Vegetable broth', 'Heavy cream', 'Basil', 'Salt and pepper'],
                'instructions': [
                    'Sauté onion and garlic',
                    'Add tomatoes and broth',
                    'Simmer 20 minutes',
                    'Blend until smooth',
                    'Stir in cream',
                    'Season and garnish with basil',
                ],
            },
            {
                'title': 'Grilled Salmon',
                'category': 'Seafood',
                'difficulty': 'Medium',
                'prep_time': 10,
                'cook_time': 15,
                'servings': 4,
                'description': 'Perfectly grilled salmon fillets',
                'ingredients': ['4 salmon fillets', 'Lemon', 'Olive oil', 'Garlic', 'Dill', 'Salt and pepper'],
                'instructions': [
                    'Marinate salmon in oil and lemon',
                    'Season with salt and pepper',
                    'Preheat grill',
                    'Grill 6-8 minutes per side',
                    'Serve with fresh dill',
                ],
            },
            {
                'title': 'Veggie Burger',
                'category': 'Vegetarian',
                'difficulty': 'Medium',
                'prep_time': 20,
                'cook_time': 15,
                'servings': 4,
                'description': 'Hearty homemade veggie burgers',
                'ingredients': ['Black beans', 'Breadcrumbs', 'Onion', 'Garlic', 'Egg', 'Cumin', 'Burger buns', 'Toppings'],
                'instructions': [
                    'Mash black beans',
                    'Mix with breadcrumbs and seasonings',
                    'Form into patties',
                    'Cook in pan or grill',
                    'Serve on buns with toppings',
                ],
            },
            {
                'title': 'Berry Smoothie',
                'category': 'Beverages',
                'difficulty': 'Easy',
                'prep_time': 5,
                'cook_time': 0,
                'servings': 2,
                'description': 'Refreshing mixed berry smoothie',
                'ingredients': ['Mixed berries', 'Banana', 'Yogurt', 'Honey', 'Milk'],
                'instructions': [
                    'Add all ingredients to blender',
                    'Blend until smooth',
                    'Adjust consistency with milk',
                    'Serve immediately',
                ],
            },
        ]

        recipes = []
        for i, data in enumerate(recipes_data):
            category = next((c for c in categories if c.name ==
                            data['category']), categories[0])
            difficulty = next((d for d in difficulty_levels if d.name ==
                              data['difficulty'].lower()), difficulty_levels[0])
            author = users[i % len(users)]

            recipe, created = Recipe.objects.get_or_create(
                title=data['title'],
                defaults={
                    'slug': slugify(data['title']),
                    'description': data['description'],
                    'category': category,
                    'difficulty_level': difficulty,
                    'author': author,
                    'prep_time': data['prep_time'],
                    'cook_time': data['cook_time'],
                    'servings': data['servings'],
                }
            )

            if created:
                # Create recipe steps (procedures)
                for step_num, instruction in enumerate(data['instructions'], start=1):
                    RecipeProcedure.objects.create(
                        recipe=recipe,
                        step_number=step_num,
                        instruction=instruction,
                    )

                # Set nutritional information
                recipe.calories_per_serving = random.randint(200, 600)
                recipe.save()

            recipes.append(recipe)

        return recipes

    def create_reviews(self, users, recipes):
        """Create reviews for recipes"""
        reviews = []
        review_texts = [
            'Absolutely delicious! My family loved it.',
            'Easy to follow and turned out great!',
            'This has become a regular in our meal rotation.',
            'Perfect recipe, will definitely make again.',
            'Tasty but took longer than expected.',
            'Great flavor combinations!',
            'Simple and satisfying.',
            'Best version of this recipe I\'ve tried.',
        ]

        for recipe in recipes:
            # Each recipe gets 2-5 reviews
            num_reviews = random.randint(2, 5)
            review_users = random.sample(users, min(num_reviews, len(users)))

            for user in review_users:
                review = RecipeRating.objects.create(
                    recipe=recipe,
                    user=user,
                    rating=random.randint(3, 5),
                    review=random.choice(review_texts),
                )
                reviews.append(review)

        return reviews

    def create_favorites(self, users, recipes):
        """Create favorite recipes for users"""
        favorites = []

        for user in users:
            # Each user favorites 3-6 random recipes
            num_favorites = random.randint(3, 6)
            favorite_recipes = random.sample(
                recipes, min(num_favorites, len(recipes)))

            for recipe in favorite_recipes:
                favorite, created = Wishlist.objects.get_or_create(
                    user=user,
                    recipe=recipe,
                )
                if created:
                    favorites.append(favorite)

        return favorites
