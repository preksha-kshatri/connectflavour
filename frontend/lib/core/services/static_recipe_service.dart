import '../models/recipe.dart';
import '../data/static_data.dart';
import 'storage_service.dart';

class StaticRecipeService {
  static const String _storageKey = 'user_recipes';
  static const String _favoritesKey = 'favorite_recipe_ids';

  // Get all recipes (static + user-created)
  Future<List<Recipe>> getRecipes() async {
    await Future.delayed(
        const Duration(milliseconds: 300)); // Simulate network delay

    final List<Recipe> allRecipes = List.from(StaticData.recipes);

    // Load user-created recipes from storage
    final userRecipes = await _getUserRecipes();
    allRecipes.addAll(userRecipes);

    // Apply favorites from storage
    final favoriteIds = await _getFavoriteIds();
    return allRecipes.map((recipe) {
      return Recipe(
        id: recipe.id,
        title: recipe.title,
        slug: recipe.slug,
        description: recipe.description,
        image: recipe.image,
        category: recipe.category,
        difficulty: recipe.difficulty,
        prepTime: recipe.prepTime,
        cookTime: recipe.cookTime,
        servings: recipe.servings,
        ingredients: recipe.ingredients,
        instructions: recipe.instructions,
        nutrition: recipe.nutrition,
        author: recipe.author,
        authorName: recipe.authorName,
        rating: recipe.rating,
        reviewCount: recipe.reviewCount,
        isFavorite: favoriteIds.contains(recipe.id),
        createdAt: recipe.createdAt,
        updatedAt: recipe.updatedAt,
      );
    }).toList();
  }

  // Get recipe by ID
  Future<Recipe?> getRecipeById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final recipes = await getRecipes();
    try {
      return recipes.firstWhere((recipe) => recipe.id == id);
    } catch (e) {
      return null;
    }
  }

  // Get recipe by slug
  Future<Recipe?> getRecipeBySlug(String slug) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final recipes = await getRecipes();
    try {
      return recipes.firstWhere((recipe) => recipe.slug == slug);
    } catch (e) {
      return null;
    }
  }

  // Get recipes by category
  Future<List<Recipe>> getRecipesByCategory(String category) async {
    final recipes = await getRecipes();
    if (category.toLowerCase() == 'all') return recipes;

    return recipes
        .where(
            (recipe) => recipe.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  // Get favorite recipes
  Future<List<Recipe>> getFavoriteRecipes() async {
    final recipes = await getRecipes();
    return recipes.where((recipe) => recipe.isFavorite).toList();
  }

  // Toggle favorite status
  Future<bool> toggleFavorite(int recipeId) async {
    final favoriteIds = await _getFavoriteIds();

    if (favoriteIds.contains(recipeId)) {
      favoriteIds.remove(recipeId);
    } else {
      favoriteIds.add(recipeId);
    }

    await StorageService.setStringList(
        _favoritesKey, favoriteIds.map((id) => id.toString()).toList());

    return favoriteIds.contains(recipeId);
  }

  // Create new recipe
  Future<Recipe> createRecipe(Recipe recipe) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final userRecipes = await _getUserRecipes();

    // Generate new ID
    final allRecipes = List.from(StaticData.recipes)..addAll(userRecipes);
    final maxId = allRecipes.isEmpty
        ? 0
        : allRecipes.map((r) => r.id).reduce((a, b) => a > b ? a : b);

    final newRecipe = Recipe(
      id: maxId + 1,
      title: recipe.title,
      slug: recipe.slug,
      description: recipe.description,
      image: recipe.image,
      category: recipe.category,
      difficulty: recipe.difficulty,
      prepTime: recipe.prepTime,
      cookTime: recipe.cookTime,
      servings: recipe.servings,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
      nutrition: recipe.nutrition,
      author: recipe.author,
      authorName: recipe.authorName,
      rating: 0.0,
      reviewCount: 0,
      isFavorite: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    userRecipes.add(newRecipe);
    await _saveUserRecipes(userRecipes);

    return newRecipe;
  }

  // Update recipe
  Future<Recipe> updateRecipe(int id, Recipe recipe) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final userRecipes = await _getUserRecipes();
    final index = userRecipes.indexWhere((r) => r.id == id);

    if (index != -1) {
      final updatedRecipe = Recipe(
        id: id,
        title: recipe.title,
        slug: recipe.slug,
        description: recipe.description,
        image: recipe.image,
        category: recipe.category,
        difficulty: recipe.difficulty,
        prepTime: recipe.prepTime,
        cookTime: recipe.cookTime,
        servings: recipe.servings,
        ingredients: recipe.ingredients,
        instructions: recipe.instructions,
        nutrition: recipe.nutrition,
        author: recipe.author,
        authorName: recipe.authorName,
        rating: recipe.rating,
        reviewCount: recipe.reviewCount,
        isFavorite: recipe.isFavorite,
        createdAt: recipe.createdAt,
        updatedAt: DateTime.now(),
      );

      userRecipes[index] = updatedRecipe;
      await _saveUserRecipes(userRecipes);
      return updatedRecipe;
    }

    throw Exception('Recipe not found or cannot be updated');
  }

  // Delete recipe
  Future<bool> deleteRecipe(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final userRecipes = await _getUserRecipes();
    final initialLength = userRecipes.length;
    userRecipes.removeWhere((r) => r.id == id);

    if (userRecipes.length < initialLength) {
      await _saveUserRecipes(userRecipes);
      return true;
    }

    return false;
  }

  // Search recipes
  Future<List<Recipe>> searchRecipes(String query) async {
    final recipes = await getRecipes();
    final lowerQuery = query.toLowerCase();

    return recipes.where((recipe) {
      return recipe.title.toLowerCase().contains(lowerQuery) ||
          recipe.description.toLowerCase().contains(lowerQuery) ||
          recipe.category.toLowerCase().contains(lowerQuery) ||
          recipe.ingredients.any((i) => i.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  // Private helper methods
  Future<List<Recipe>> _getUserRecipes() async {
    final jsonList = StorageService.getJsonList(_storageKey);
    if (jsonList == null) return [];

    try {
      return jsonList.map((json) => Recipe.fromJson(json)).toList();
    } catch (e) {
      print('Error loading user recipes: $e');
      return [];
    }
  }

  Future<void> _saveUserRecipes(List<Recipe> recipes) async {
    final jsonList = recipes.map((r) => r.toJson()).toList();
    await StorageService.setJsonList(_storageKey, jsonList);
  }

  Future<Set<int>> _getFavoriteIds() async {
    final stringList = StorageService.getStringList(_favoritesKey);
    if (stringList == null) return {};

    return stringList
        .map((s) => int.tryParse(s) ?? 0)
        .where((id) => id > 0)
        .toSet();
  }
}
