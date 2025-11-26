import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectflavour/shared/widgets/desktop_app_bar.dart';

/// Desktop-optimized create recipe page with form layout
class DesktopCreateRecipePage extends StatefulWidget {
  const DesktopCreateRecipePage({super.key});

  @override
  State<DesktopCreateRecipePage> createState() =>
      _DesktopCreateRecipePageState();
}

class _DesktopCreateRecipePageState extends State<DesktopCreateRecipePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _cookTimeController = TextEditingController();
  final _servingsController = TextEditingController();

  final List<String> _ingredients = [''];
  final List<String> _instructions = [''];
  String _selectedCategory = 'Dinner';
  String _selectedDifficulty = 'Medium';
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _prepTimeController.dispose();
    _cookTimeController.dispose();
    _servingsController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe created successfully!')),
      );
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          // Desktop App Bar
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: theme.dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Create New Recipe',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                DesktopToolbar(
                  actions: [
                    ToolbarAction(
                      label: 'Save Draft',
                      icon: Icons.drafts,
                      onPressed: () {},
                    ),
                    ToolbarAction(
                      label: _isLoading ? 'Publishing...' : 'Publish',
                      icon: Icons.publish,
                      onPressed: _isLoading ? null : _handleSubmit,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Form Content
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  padding: const EdgeInsets.all(40),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column - Main Details
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Recipe Image Upload
                              _buildImageUpload(),
                              const SizedBox(height: 32),

                              // Title
                              TextFormField(
                                controller: _titleController,
                                decoration: InputDecoration(
                                  labelText: 'Recipe Title',
                                  hintText: 'Enter a catchy title',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                style: const TextStyle(fontSize: 16),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a title';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),

                              // Description
                              TextFormField(
                                controller: _descriptionController,
                                decoration: InputDecoration(
                                  labelText: 'Description',
                                  hintText: 'Describe your recipe',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                maxLines: 3,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 32),

                              // Ingredients
                              _buildIngredientsSection(),
                              const SizedBox(height: 32),

                              // Instructions
                              _buildInstructionsSection(),
                            ],
                          ),
                        ),
                        const SizedBox(width: 40),

                        // Right Column - Metadata
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildMetadataCard(),
                              const SizedBox(height: 20),
                              _buildNutritionCard(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUpload() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Implement image upload
        },
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cloud_upload, size: 64, color: Colors.grey.shade400),
              const SizedBox(height: 16),
              Text(
                'Click to upload recipe image',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'PNG, JPG up to 10MB',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIngredientsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Ingredients',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                setState(() => _ingredients.add(''));
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Ingredient'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._ingredients.asMap().entries.map((entry) {
          final index = entry.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'e.g., 2 cups flour',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) => _ingredients[index] = value,
                  ),
                ),
                if (_ingredients.length > 1) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                    onPressed: () {
                      setState(() => _ingredients.removeAt(index));
                    },
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInstructionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Instructions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: () {
                setState(() => _instructions.add(''));
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Step'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._instructions.asMap().entries.map((entry) {
          final index = entry.key;
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Describe this step...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    maxLines: 2,
                    onChanged: (value) => _instructions[index] = value,
                  ),
                ),
                if (_instructions.length > 1) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    color: Colors.red,
                    onPressed: () {
                      setState(() => _instructions.removeAt(index));
                    },
                  ),
                ],
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMetadataCard() {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Recipe Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Category
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: ['Breakfast', 'Lunch', 'Dinner', 'Dessert', 'Snacks']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),
            const SizedBox(height: 16),

            // Difficulty
            DropdownButtonFormField<String>(
              initialValue: _selectedDifficulty,
              decoration: InputDecoration(
                labelText: 'Difficulty',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: ['Easy', 'Medium', 'Hard']
                  .map((diff) =>
                      DropdownMenuItem(value: diff, child: Text(diff)))
                  .toList(),
              onChanged: (value) {
                setState(() => _selectedDifficulty = value!);
              },
            ),
            const SizedBox(height: 16),

            // Prep Time
            TextFormField(
              controller: _prepTimeController,
              decoration: InputDecoration(
                labelText: 'Prep Time (minutes)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Cook Time
            TextFormField(
              controller: _cookTimeController,
              decoration: InputDecoration(
                labelText: 'Cook Time (minutes)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            // Servings
            TextFormField(
              controller: _servingsController,
              decoration: InputDecoration(
                labelText: 'Servings',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nutrition (Optional)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Add nutritional information per serving',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 20),
            _buildNutritionField('Calories', 'kcal'),
            const SizedBox(height: 12),
            _buildNutritionField('Protein', 'g'),
            const SizedBox(height: 12),
            _buildNutritionField('Carbs', 'g'),
            const SizedBox(height: 12),
            _buildNutritionField('Fat', 'g'),
          ],
        ),
      ),
    );
  }

  Widget _buildNutritionField(String label, String unit) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        SizedBox(
          width: 100,
          child: TextFormField(
            decoration: InputDecoration(
              suffixText: unit,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
            ),
            keyboardType: TextInputType.number,
          ),
        ),
      ],
    );
  }
}
