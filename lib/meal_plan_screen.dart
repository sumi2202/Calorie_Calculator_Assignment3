import 'package:flutter/material.dart';

import 'food_model.dart';
class MealPlanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Food> selectedFoods = ModalRoute.of(context)!.settings.arguments as List<Food>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Plan'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Selected Food Items for Date'),
          Expanded(
            child: ListView.builder(
              itemCount: selectedFoods.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(selectedFoods[index].name),
                  subtitle: Text('${selectedFoods[index].calories} calories'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}