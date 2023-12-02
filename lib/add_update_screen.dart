import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'food_model.dart';

class AddUpdateScreen extends StatefulWidget {
  final bool isUpdate;

  AddUpdateScreen({required this.isUpdate});

  @override
  _AddUpdateScreenState createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController caloriesController = TextEditingController();
  late DatabaseHelper databaseHelper;

  @override
  void initState() {
    super.initState();
    databaseHelper = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.isUpdate ? const Text('Update Food Entry') : const Text('Add Food Entry'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Food Name'),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Calories'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String name = nameController.text.trim();
                double calories = double.tryParse(caloriesController.text) ?? 0;

                if (name.isNotEmpty && calories > 0) {
                  Food food = Food(id: 0, name: name, calories: calories, date: DateTime(2023, 12, 1));

                  if (widget.isUpdate) {
                    // Handle update logic
                    databaseHelper.updateFood(food);
                  } else {
                    // Handle add logic
                    await databaseHelper.insertFood(food);
                  }

                  // Navigate back to HomeScreen after adding/updating
                  Navigator.pop(context);
                } else {
                  // Show an error message if name or calories are not valid
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter valid food name and calories.'),
                    ),
                  );
                }
              },
              child: Text(widget.isUpdate ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }
}
