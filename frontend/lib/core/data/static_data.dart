import '../models/recipe.dart';
import '../models/category.dart';
import '../models/user.dart';

class StaticData {
  // Static Categories
  static final List<Category> categories = [
    Category(
      id: 1,
      name: 'Breakfast',
      slug: 'breakfast',
      description: 'Start your day with delicious breakfast recipes',
      icon: '🍳',
      recipesCount: 8,
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
    ),
    Category(
      id: 2,
      name: 'Lunch',
      slug: 'lunch',
      description: 'Satisfying lunch ideas for every taste',
      icon: '🥗',
      recipesCount: 6,
      createdAt: DateTime.now().subtract(const Duration(days: 360)),
    ),
    Category(
      id: 3,
      name: 'Dinner',
      slug: 'dinner',
      description: 'Perfect dinner recipes for any occasion',
      icon: '🍽️',
      recipesCount: 10,
      createdAt: DateTime.now().subtract(const Duration(days: 355)),
    ),
    Category(
      id: 4,
      name: 'Desserts',
      slug: 'desserts',
      description: 'Sweet treats and delightful desserts',
      icon: '🍰',
      recipesCount: 7,
      createdAt: DateTime.now().subtract(const Duration(days: 350)),
    ),
    Category(
      id: 5,
      name: 'Appetizers',
      slug: 'appetizers',
      description: 'Perfect starters for your meals',
      icon: '🥙',
      recipesCount: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 345)),
    ),
    Category(
      id: 6,
      name: 'Beverages',
      slug: 'beverages',
      description: 'Refreshing drinks and smoothies',
      icon: '🥤',
      recipesCount: 4,
      createdAt: DateTime.now().subtract(const Duration(days: 340)),
    ),
    Category(
      id: 7,
      name: 'Snacks',
      slug: 'snacks',
      description: 'Quick and tasty snack ideas',
      icon: '🍿',
      recipesCount: 6,
      createdAt: DateTime.now().subtract(const Duration(days: 335)),
    ),
    Category(
      id: 8,
      name: 'Salads',
      slug: 'salads',
      description: 'Fresh and healthy salad recipes',
      icon: '🥬',
      recipesCount: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 330)),
    ),
  ];

  // Static Users
  static final List<User> users = [
    User(
      id: 1,
      username: 'chef_emily',
      email: 'emily@connectflavour.com',
      firstName: 'Emily',
      lastName: 'Johnson',
      fullName: 'Emily Johnson',
      bio:
          'Professional chef with 15 years of experience. Love creating fusion dishes!',
      profilePicture: 'https://i.pravatar.cc/300?img=1',
      location: 'New York, USA',
      isVerified: true,
      dateJoined: DateTime.now().subtract(const Duration(days: 730)),
      recipesCount: 24,
      followersCount: 1520,
      followingCount: 340,
      dietaryPreferences: ['Vegetarian-friendly'],
      preferredCategories: ['Dinner', 'Desserts'],
    ),
    User(
      id: 2,
      username: 'healthyeats_mark',
      email: 'mark@connectflavour.com',
      firstName: 'Mark',
      lastName: 'Chen',
      fullName: 'Mark Chen',
      bio:
          'Nutritionist and healthy food enthusiast. Making healthy eating delicious!',
      profilePicture: 'https://i.pravatar.cc/300?img=12',
      location: 'San Francisco, USA',
      isVerified: true,
      dateJoined: DateTime.now().subtract(const Duration(days: 550)),
      recipesCount: 18,
      followersCount: 890,
      followingCount: 120,
      dietaryPreferences: ['Vegan', 'Gluten-free'],
      preferredCategories: ['Breakfast', 'Salads'],
    ),
    User(
      id: 3,
      username: 'pasta_lover_sarah',
      email: 'sarah@connectflavour.com',
      firstName: 'Sarah',
      lastName: 'Martinez',
      fullName: 'Sarah Martinez',
      bio: 'Italian cuisine specialist. Pasta is life! 🍝',
      profilePicture: 'https://i.pravatar.cc/300?img=5',
      location: 'Rome, Italy',
      isVerified: true,
      dateJoined: DateTime.now().subtract(const Duration(days: 420)),
      recipesCount: 31,
      followersCount: 2100,
      followingCount: 280,
      dietaryPreferences: [],
      preferredCategories: ['Lunch', 'Dinner'],
    ),
    User(
      id: 4,
      username: 'baker_james',
      email: 'james@connectflavour.com',
      firstName: 'James',
      lastName: 'Wilson',
      fullName: 'James Wilson',
      bio: 'Pastry chef and baking instructor. Sweet creations are my passion!',
      profilePicture: 'https://i.pravatar.cc/300?img=13',
      location: 'London, UK',
      isVerified: true,
      dateJoined: DateTime.now().subtract(const Duration(days: 280)),
      recipesCount: 22,
      followersCount: 1340,
      followingCount: 190,
      dietaryPreferences: ['Vegetarian-friendly'],
      preferredCategories: ['Desserts', 'Breakfast'],
    ),
  ];

  // Static Recipes
  static final List<Recipe> recipes = [
    // BREAKFAST RECIPES
    Recipe(
      id: 1,
      title: 'Classic French Toast',
      slug: 'classic-french-toast',
      description:
          'Perfectly golden and fluffy French toast with a hint of vanilla and cinnamon. A breakfast classic that never fails to impress.',
      image:
          'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=800',
      category: 'Breakfast',
      difficulty: 'Easy',
      prepTime: 10,
      cookTime: 15,
      servings: 4,
      ingredients: [
        '8 slices of thick bread',
        '4 large eggs',
        '1 cup whole milk',
        '2 tablespoons sugar',
        '1 teaspoon vanilla extract',
        '1/2 teaspoon ground cinnamon',
        'Butter for cooking',
        'Maple syrup for serving',
        'Fresh berries for garnish',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction:
                'In a shallow bowl, whisk together eggs, milk, sugar, vanilla, and cinnamon until well combined.'),
        RecipeStep(
            stepNumber: 2,
            instruction:
                'Heat a large skillet or griddle over medium heat and add a pat of butter.'),
        RecipeStep(
            stepNumber: 3,
            instruction:
                'Dip each bread slice into the egg mixture, coating both sides evenly.'),
        RecipeStep(
            stepNumber: 4,
            instruction:
                'Place the coated bread slices on the hot skillet and cook for 3-4 minutes per side until golden brown.'),
        RecipeStep(
            stepNumber: 5,
            instruction:
                'Serve immediately with maple syrup and fresh berries.'),
      ],
      nutrition: NutritionInfo(
        calories: 320,
        protein: 12,
        carbs: 45,
        fat: 10,
        fiber: 2,
      ),
      author: '1',
      authorName: 'Emily Johnson',
      rating: 4.8,
      reviewCount: 156,
      isFavorite: false,
      createdAt: DateTime.now().subtract(const Duration(days: 45)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Recipe(
      id: 2,
      title: 'Avocado Toast with Poached Egg',
      slug: 'avocado-toast-poached-egg',
      description:
          'Creamy avocado on crispy toast topped with a perfectly poached egg. A nutritious and Instagram-worthy breakfast!',
      image:
          'https://images.unsplash.com/photo-1541519227354-08fa5d50c44d?w=800',
      category: 'Breakfast',
      difficulty: 'Easy',
      prepTime: 10,
      cookTime: 10,
      servings: 2,
      ingredients: [
        '2 ripe avocados',
        '4 slices sourdough bread',
        '4 eggs',
        '1 tablespoon white vinegar',
        'Salt and pepper to taste',
        'Red pepper flakes',
        'Fresh lemon juice',
        'Olive oil',
        'Fresh herbs for garnish',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction:
                'Toast the sourdough bread slices until golden and crispy.'),
        RecipeStep(
            stepNumber: 2,
            instruction: 'Mash avocados with lemon juice, salt, and pepper.'),
        RecipeStep(
            stepNumber: 3,
            instruction:
                'Bring a pot of water to a gentle simmer and add vinegar.'),
        RecipeStep(
            stepNumber: 4,
            instruction:
                'Crack eggs into the simmering water and poach for 3-4 minutes.'),
        RecipeStep(
            stepNumber: 5,
            instruction:
                'Spread avocado on toast, top with poached egg, season with salt, pepper, and red pepper flakes.'),
      ],
      nutrition: NutritionInfo(
        calories: 380,
        protein: 16,
        carbs: 32,
        fat: 22,
        fiber: 10,
      ),
      author: '2',
      authorName: 'Mark Chen',
      rating: 4.9,
      reviewCount: 243,
      isFavorite: false,
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Recipe(
      id: 3,
      title: 'Blueberry Pancakes',
      slug: 'blueberry-pancakes',
      description:
          'Fluffy buttermilk pancakes loaded with fresh blueberries. Perfect for a weekend breakfast!',
      image:
          'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=800',
      category: 'Breakfast',
      difficulty: 'Easy',
      prepTime: 15,
      cookTime: 20,
      servings: 4,
      ingredients: [
        '2 cups all-purpose flour',
        '2 tablespoons sugar',
        '2 teaspoons baking powder',
        '1/2 teaspoon salt',
        '2 eggs',
        '1 3/4 cups buttermilk',
        '1/4 cup melted butter',
        '1 cup fresh blueberries',
        'Maple syrup for serving',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction:
                'Mix flour, sugar, baking powder, and salt in a large bowl.'),
        RecipeStep(
            stepNumber: 2,
            instruction:
                'In another bowl, whisk eggs, buttermilk, and melted butter.'),
        RecipeStep(
            stepNumber: 3,
            instruction:
                'Combine wet and dry ingredients until just mixed (some lumps are okay).'),
        RecipeStep(stepNumber: 4, instruction: 'Gently fold in blueberries.'),
        RecipeStep(
            stepNumber: 5,
            instruction:
                'Cook pancakes on a greased griddle over medium heat until bubbles form, then flip.'),
      ],
      nutrition: NutritionInfo(
        calories: 420,
        protein: 11,
        carbs: 58,
        fat: 15,
        fiber: 3,
      ),
      author: '4',
      authorName: 'James Wilson',
      rating: 4.7,
      reviewCount: 189,
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
    ),

    // LUNCH RECIPES
    Recipe(
      id: 4,
      title: 'Caesar Salad with Grilled Chicken',
      slug: 'caesar-salad-grilled-chicken',
      description:
          'Classic Caesar salad with crispy romaine lettuce, homemade dressing, parmesan, and perfectly grilled chicken breast.',
      image: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=800',
      category: 'Lunch',
      difficulty: 'Medium',
      prepTime: 20,
      cookTime: 15,
      servings: 4,
      ingredients: [
        '2 chicken breasts',
        '1 large romaine lettuce head',
        '1/2 cup parmesan cheese, grated',
        '1 cup croutons',
        '1/2 cup Caesar dressing',
        '2 tablespoons olive oil',
        'Salt and pepper',
        'Lemon wedges',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction:
                'Season chicken breasts with salt, pepper, and olive oil.'),
        RecipeStep(
            stepNumber: 2,
            instruction:
                'Grill chicken for 6-7 minutes per side until cooked through. Let rest for 5 minutes.'),
        RecipeStep(
            stepNumber: 3,
            instruction: 'Chop romaine lettuce and place in a large bowl.'),
        RecipeStep(
            stepNumber: 4,
            instruction: 'Add Caesar dressing and toss to coat evenly.'),
        RecipeStep(
            stepNumber: 5,
            instruction:
                'Slice chicken, top salad with chicken, croutons, and extra parmesan.'),
      ],
      nutrition: NutritionInfo(
        calories: 380,
        protein: 32,
        carbs: 18,
        fat: 20,
        fiber: 3,
      ),
      author: '2',
      authorName: 'Mark Chen',
      rating: 4.6,
      reviewCount: 134,
      isFavorite: false,
      createdAt: DateTime.now().subtract(const Duration(days: 40)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Recipe(
      id: 5,
      title: 'Mediterranean Quinoa Bowl',
      slug: 'mediterranean-quinoa-bowl',
      description:
          'Nutritious quinoa bowl packed with fresh vegetables, feta cheese, olives, and a tangy lemon dressing.',
      image:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
      category: 'Lunch',
      difficulty: 'Easy',
      prepTime: 15,
      cookTime: 20,
      servings: 4,
      ingredients: [
        '2 cups quinoa',
        '1 cucumber, diced',
        '2 tomatoes, diced',
        '1 red onion, sliced',
        '1 cup feta cheese',
        '1/2 cup kalamata olives',
        '1/4 cup olive oil',
        '2 tablespoons lemon juice',
        'Fresh parsley',
        'Salt and pepper',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction:
                'Cook quinoa according to package instructions and let cool.'),
        RecipeStep(
            stepNumber: 2,
            instruction: 'Chop all vegetables into bite-sized pieces.'),
        RecipeStep(
            stepNumber: 3,
            instruction:
                'Mix olive oil, lemon juice, salt, and pepper for dressing.'),
        RecipeStep(
            stepNumber: 4,
            instruction:
                'Combine quinoa, vegetables, olives, and feta in a large bowl.'),
        RecipeStep(
            stepNumber: 5,
            instruction:
                'Drizzle with dressing, garnish with parsley, and serve.'),
      ],
      nutrition: NutritionInfo(
        calories: 420,
        protein: 14,
        carbs: 48,
        fat: 18,
        fiber: 8,
      ),
      author: '2',
      authorName: 'Mark Chen',
      rating: 4.8,
      reviewCount: 201,
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(days: 25)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),

    // DINNER RECIPES
    Recipe(
      id: 6,
      title: 'Spaghetti Carbonara',
      slug: 'spaghetti-carbonara',
      description:
          'Authentic Italian carbonara with crispy pancetta, eggs, and parmesan. Simple yet incredibly delicious!',
      image:
          'https://images.unsplash.com/photo-1612874742237-6526221588e3?w=800',
      category: 'Dinner',
      difficulty: 'Medium',
      prepTime: 10,
      cookTime: 20,
      servings: 4,
      ingredients: [
        '400g spaghetti',
        '200g pancetta or guanciale',
        '4 large eggs',
        '1 cup parmesan cheese, grated',
        '2 garlic cloves',
        'Black pepper',
        'Salt',
        'Fresh parsley',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction:
                'Cook spaghetti in salted boiling water until al dente.'),
        RecipeStep(
            stepNumber: 2,
            instruction:
                'Fry pancetta with garlic until crispy, remove garlic.'),
        RecipeStep(
            stepNumber: 3,
            instruction: 'Beat eggs with parmesan and lots of black pepper.'),
        RecipeStep(
            stepNumber: 4,
            instruction: 'Drain pasta, reserving 1 cup of pasta water.'),
        RecipeStep(
            stepNumber: 5,
            instruction:
                'Toss hot pasta with pancetta, then off heat, mix in egg mixture, adding pasta water to create creamy sauce.'),
      ],
      nutrition: NutritionInfo(
        calories: 580,
        protein: 28,
        carbs: 72,
        fat: 18,
        fiber: 3,
      ),
      author: '3',
      authorName: 'Sarah Martinez',
      rating: 4.9,
      reviewCount: 387,
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(days: 50)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Recipe(
      id: 7,
      title: 'Grilled Salmon with Lemon Herb Butter',
      slug: 'grilled-salmon-lemon-herb-butter',
      description:
          'Perfectly grilled salmon fillets topped with a luxurious lemon herb butter. Healthy and restaurant-quality!',
      image:
          'https://images.unsplash.com/photo-1485921325833-c519f76c4927?w=800',
      category: 'Dinner',
      difficulty: 'Medium',
      prepTime: 15,
      cookTime: 15,
      servings: 4,
      ingredients: [
        '4 salmon fillets (6oz each)',
        '1/2 cup butter, softened',
        '2 tablespoons fresh lemon juice',
        '1 tablespoon fresh dill',
        '1 tablespoon fresh parsley',
        '2 garlic cloves, minced',
        'Salt and pepper',
        'Lemon slices',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction:
                'Mix softened butter with lemon juice, herbs, and garlic.'),
        RecipeStep(
            stepNumber: 2,
            instruction: 'Season salmon fillets with salt and pepper.'),
        RecipeStep(
            stepNumber: 3, instruction: 'Preheat grill to medium-high heat.'),
        RecipeStep(
            stepNumber: 4,
            instruction:
                'Grill salmon skin-side down for 6 minutes, flip and cook 4 more minutes.'),
        RecipeStep(
            stepNumber: 5,
            instruction:
                'Top each fillet with herb butter and serve with lemon slices.'),
      ],
      nutrition: NutritionInfo(
        calories: 420,
        protein: 38,
        carbs: 2,
        fat: 28,
        fiber: 0,
      ),
      author: '1',
      authorName: 'Emily Johnson',
      rating: 4.8,
      reviewCount: 267,
      isFavorite: false,
      createdAt: DateTime.now().subtract(const Duration(days: 35)),
      updatedAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    Recipe(
      id: 8,
      title: 'Chicken Tikka Masala',
      slug: 'chicken-tikka-masala',
      description:
          'Tender chicken pieces in a creamy, spiced tomato sauce. A beloved Indian restaurant favorite you can make at home!',
      image:
          'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=800',
      category: 'Dinner',
      difficulty: 'Hard',
      prepTime: 30,
      cookTime: 40,
      servings: 6,
      ingredients: [
        '800g chicken breast, cubed',
        '1 cup yogurt',
        '2 tablespoons tikka masala spice',
        '1 can (400ml) crushed tomatoes',
        '1 cup heavy cream',
        '1 onion, diced',
        '4 garlic cloves, minced',
        '1 tablespoon ginger, minced',
        '2 tablespoons butter',
        'Fresh cilantro',
        'Basmati rice for serving',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction:
                'Marinate chicken in yogurt and half the spices for 30 minutes.'),
        RecipeStep(
            stepNumber: 2,
            instruction:
                'Grill or broil chicken until charred and cooked through.'),
        RecipeStep(
            stepNumber: 3,
            instruction:
                'Sauté onion, garlic, and ginger in butter until softened.'),
        RecipeStep(
            stepNumber: 4,
            instruction:
                'Add remaining spices, tomatoes, and simmer for 15 minutes.'),
        RecipeStep(
            stepNumber: 5,
            instruction:
                'Stir in cream and chicken, simmer 10 minutes. Garnish with cilantro and serve with rice.'),
      ],
      nutrition: NutritionInfo(
        calories: 520,
        protein: 42,
        carbs: 24,
        fat: 28,
        fiber: 3,
      ),
      author: '1',
      authorName: 'Emily Johnson',
      rating: 4.9,
      reviewCount: 412,
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(days: 55)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),

    // DESSERT RECIPES
    Recipe(
      id: 9,
      title: 'Chocolate Lava Cake',
      slug: 'chocolate-lava-cake',
      description:
          'Decadent chocolate cake with a molten center. The ultimate chocolate lover\'s dessert!',
      image:
          'https://images.unsplash.com/photo-1624353365286-3f8d62daad51?w=800',
      category: 'Desserts',
      difficulty: 'Medium',
      prepTime: 15,
      cookTime: 12,
      servings: 4,
      ingredients: [
        '200g dark chocolate',
        '1/2 cup butter',
        '2 eggs',
        '2 egg yolks',
        '1/4 cup sugar',
        '2 tablespoons flour',
        'Butter for ramekins',
        'Cocoa powder for dusting',
        'Vanilla ice cream for serving',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction:
                'Preheat oven to 425°F (220°C). Butter and flour 4 ramekins.'),
        RecipeStep(
            stepNumber: 2,
            instruction:
                'Melt chocolate and butter together, let cool slightly.'),
        RecipeStep(
            stepNumber: 3,
            instruction:
                'Beat eggs, egg yolks, and sugar until thick and pale.'),
        RecipeStep(
            stepNumber: 4,
            instruction: 'Fold chocolate mixture and flour into eggs.'),
        RecipeStep(
            stepNumber: 5,
            instruction:
                'Pour into ramekins, bake 12 minutes. Centers should be soft. Invert onto plates and serve with ice cream.'),
      ],
      nutrition: NutritionInfo(
        calories: 480,
        protein: 8,
        carbs: 42,
        fat: 32,
        fiber: 3,
      ),
      author: '4',
      authorName: 'James Wilson',
      rating: 4.9,
      reviewCount: 523,
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(days: 70)),
      updatedAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Recipe(
      id: 10,
      title: 'Classic Tiramisu',
      slug: 'classic-tiramisu',
      description:
          'Authentic Italian tiramisu with layers of coffee-soaked ladyfingers and mascarpone cream. A timeless classic!',
      image:
          'https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?w=800',
      category: 'Desserts',
      difficulty: 'Medium',
      prepTime: 30,
      cookTime: 0,
      servings: 8,
      ingredients: [
        '6 egg yolks',
        '3/4 cup sugar',
        '500g mascarpone cheese',
        '1 3/4 cups heavy cream',
        '2 cups strong espresso, cooled',
        '3 tablespoons coffee liqueur',
        '24 ladyfinger cookies',
        'Cocoa powder for dusting',
        'Dark chocolate shavings',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction:
                'Whisk egg yolks and sugar over double boiler until thick and pale.'),
        RecipeStep(
            stepNumber: 2,
            instruction:
                'Beat mascarpone until smooth, then fold into egg mixture.'),
        RecipeStep(
            stepNumber: 3,
            instruction:
                'Whip cream to stiff peaks and fold into mascarpone mixture.'),
        RecipeStep(
            stepNumber: 4,
            instruction:
                'Mix espresso and liqueur. Quickly dip ladyfingers and layer in dish.'),
        RecipeStep(
            stepNumber: 5,
            instruction:
                'Alternate layers of ladyfingers and cream. Refrigerate 4 hours. Dust with cocoa before serving.'),
      ],
      nutrition: NutritionInfo(
        calories: 420,
        protein: 9,
        carbs: 38,
        fat: 26,
        fiber: 1,
      ),
      author: '3',
      authorName: 'Sarah Martinez',
      rating: 4.8,
      reviewCount: 345,
      isFavorite: false,
      createdAt: DateTime.now().subtract(const Duration(days: 80)),
      updatedAt: DateTime.now().subtract(const Duration(days: 6)),
    ),

    // APPETIZER RECIPES
    Recipe(
      id: 11,
      title: 'Bruschetta with Tomato and Basil',
      slug: 'bruschetta-tomato-basil',
      description:
          'Classic Italian appetizer with fresh tomatoes, basil, and garlic on toasted bread. Simple and delicious!',
      image:
          'https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?w=800',
      category: 'Appetizers',
      difficulty: 'Easy',
      prepTime: 15,
      cookTime: 5,
      servings: 6,
      ingredients: [
        '1 French baguette',
        '4 ripe tomatoes, diced',
        '3 garlic cloves, minced',
        '1/4 cup fresh basil, chopped',
        '2 tablespoons olive oil',
        '1 tablespoon balsamic vinegar',
        'Salt and pepper',
        'Parmesan cheese (optional)',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction: 'Slice baguette and toast until golden.'),
        RecipeStep(
            stepNumber: 2,
            instruction:
                'Mix tomatoes, garlic, basil, olive oil, and balsamic.'),
        RecipeStep(
            stepNumber: 3,
            instruction:
                'Season with salt and pepper, let marinate 10 minutes.'),
        RecipeStep(
            stepNumber: 4, instruction: 'Rub toasted bread with garlic clove.'),
        RecipeStep(
            stepNumber: 5,
            instruction:
                'Top bread with tomato mixture and serve immediately.'),
      ],
      nutrition: NutritionInfo(
        calories: 180,
        protein: 5,
        carbs: 28,
        fat: 6,
        fiber: 2,
      ),
      author: '3',
      authorName: 'Sarah Martinez',
      rating: 4.7,
      reviewCount: 198,
      isFavorite: false,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),

    // BEVERAGE RECIPES
    Recipe(
      id: 12,
      title: 'Mango Smoothie Bowl',
      slug: 'mango-smoothie-bowl',
      description:
          'Tropical mango smoothie bowl topped with fresh fruits, granola, and coconut flakes. Perfect healthy breakfast or snack!',
      image:
          'https://images.unsplash.com/photo-1590301157890-4810ed352733?w=800',
      category: 'Beverages',
      difficulty: 'Easy',
      prepTime: 10,
      cookTime: 0,
      servings: 2,
      ingredients: [
        '2 frozen mangoes',
        '1 banana',
        '1/2 cup Greek yogurt',
        '1/4 cup coconut milk',
        '1 tablespoon honey',
        'Granola for topping',
        'Fresh berries for topping',
        'Coconut flakes',
        'Chia seeds',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction:
                'Blend frozen mango, banana, yogurt, coconut milk, and honey until smooth.'),
        RecipeStep(stepNumber: 2, instruction: 'Pour into bowls.'),
        RecipeStep(
            stepNumber: 3,
            instruction:
                'Top with granola, fresh berries, coconut flakes, and chia seeds.'),
        RecipeStep(stepNumber: 4, instruction: 'Serve immediately and enjoy!'),
      ],
      nutrition: NutritionInfo(
        calories: 320,
        protein: 12,
        carbs: 58,
        fat: 8,
        fiber: 6,
      ),
      author: '2',
      authorName: 'Mark Chen',
      rating: 4.6,
      reviewCount: 142,
      isFavorite: false,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),

    // SNACK RECIPES
    Recipe(
      id: 13,
      title: 'Homemade Hummus',
      slug: 'homemade-hummus',
      description:
          'Creamy, smooth hummus made from scratch. Perfect with pita bread, vegetables, or as a spread!',
      image:
          'https://images.unsplash.com/photo-1571067485120-ccaee6f5de7a?w=800',
      category: 'Snacks',
      difficulty: 'Easy',
      prepTime: 10,
      cookTime: 0,
      servings: 8,
      ingredients: [
        '2 cans chickpeas, drained',
        '1/4 cup tahini',
        '1/4 cup lemon juice',
        '2 garlic cloves',
        '2 tablespoons olive oil',
        '1/2 teaspoon cumin',
        'Salt to taste',
        'Water as needed',
        'Paprika and parsley for garnish',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction:
                'Add chickpeas, tahini, lemon juice, garlic, and cumin to food processor.'),
        RecipeStep(
            stepNumber: 2,
            instruction:
                'Blend until smooth, adding water to reach desired consistency.'),
        RecipeStep(stepNumber: 3, instruction: 'Season with salt to taste.'),
        RecipeStep(
            stepNumber: 4,
            instruction: 'Transfer to serving bowl, drizzle with olive oil.'),
        RecipeStep(
            stepNumber: 5,
            instruction:
                'Garnish with paprika and parsley. Serve with pita bread or vegetables.'),
      ],
      nutrition: NutritionInfo(
        calories: 140,
        protein: 6,
        carbs: 18,
        fat: 6,
        fiber: 5,
      ),
      author: '2',
      authorName: 'Mark Chen',
      rating: 4.7,
      reviewCount: 176,
      isFavorite: true,
      createdAt: DateTime.now().subtract(const Duration(days: 28)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),

    // SALAD RECIPES
    Recipe(
      id: 14,
      title: 'Greek Salad',
      slug: 'greek-salad',
      description:
          'Fresh and vibrant Greek salad with cucumbers, tomatoes, olives, and feta cheese. A Mediterranean classic!',
      image:
          'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=800',
      category: 'Salads',
      difficulty: 'Easy',
      prepTime: 15,
      cookTime: 0,
      servings: 4,
      ingredients: [
        '3 large tomatoes, chopped',
        '1 cucumber, sliced',
        '1 red onion, thinly sliced',
        '1 green bell pepper, chopped',
        '1 cup kalamata olives',
        '200g feta cheese, cubed',
        '1/4 cup olive oil',
        '2 tablespoons red wine vinegar',
        '1 teaspoon oregano',
        'Salt and pepper',
      ],
      instructions: [
        RecipeStep(
            stepNumber: 1,
            instruction: 'Chop all vegetables into bite-sized pieces.'),
        RecipeStep(
            stepNumber: 2,
            instruction:
                'Combine tomatoes, cucumber, onion, bell pepper, and olives in a large bowl.'),
        RecipeStep(
            stepNumber: 3,
            instruction:
                'Whisk olive oil, vinegar, oregano, salt, and pepper.'),
        RecipeStep(
            stepNumber: 4,
            instruction: 'Pour dressing over vegetables and toss gently.'),
        RecipeStep(
            stepNumber: 5,
            instruction: 'Top with feta cheese and serve immediately.'),
      ],
      nutrition: NutritionInfo(
        calories: 280,
        protein: 8,
        carbs: 14,
        fat: 22,
        fiber: 4,
      ),
      author: '2',
      authorName: 'Mark Chen',
      rating: 4.8,
      reviewCount: 234,
      isFavorite: false,
      createdAt: DateTime.now().subtract(const Duration(days: 18)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Helper methods
  static Recipe? getRecipeById(int id) {
    try {
      return recipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }

  static Recipe? getRecipeBySlug(String slug) {
    try {
      return recipes.firstWhere((recipe) => recipe.slug == slug);
    } catch (e) {
      return null;
    }
  }

  static List<Recipe> getRecipesByCategory(String category) {
    if (category.toLowerCase() == 'all') return recipes;
    return recipes
        .where(
            (recipe) => recipe.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  static List<Recipe> getFavoriteRecipes() {
    return recipes.where((recipe) => recipe.isFavorite).toList();
  }

  static User? getUserById(int id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  static Category? getCategoryBySlug(String slug) {
    try {
      return categories.firstWhere((category) => category.slug == slug);
    } catch (e) {
      return null;
    }
  }
}
