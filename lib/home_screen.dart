import 'package:flutter/material.dart';
import 'add_update_screen.dart';
import 'database_helper.dart';
import 'food_model.dart';
import 'meal_plan_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController targetCaloriesController = TextEditingController();
  TextEditingController dateController = TextEditingController();
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
        title: const Text('Calories Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('List of Food Items', style: Theme.of(context).textTheme.headline6),
            Expanded(
              child: FutureBuilder<List<Food>>(
                future: databaseHelper.getAllFoods(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No food items available.');
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(snapshot.data![index].name),
                          subtitle: Text('${snapshot.data![index].calories} calories'),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Text('Target Calories per Day', style: Theme.of(context).textTheme.headline6),
            TextFormField(
              controller: targetCaloriesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter Target Calories'),
            ),
            const SizedBox(height: 20),
            Text('Date Selection', style: Theme.of(context).textTheme.headline6),
            TextFormField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Select Date'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                DateTime selectedDate = DateTime.parse(dateController.text.trim());
                double targetCalories = double.tryParse(targetCaloriesController.text) ?? 0;

                // Retrieve food items for the selected date
                List<Food> selectedFoods = await databaseHelper.getMealPlanForDate(selectedDate);

                // Calculate total calories
                double totalCalories = selectedFoods.fold(0, (sum, food) => sum + food.calories);

                if (totalCalories <= targetCalories) {
                  // Navigate to the Meal Plan screen
                  Navigator.pushNamed(context, '/mealPlan', arguments: selectedFoods);
                } else {
                  // Show an error message if total calories exceed the target
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Total calories exceed the target. Please adjust your selection.'),
                    ),
                  );
                }
              },
              child: const Text('View Meal Plan'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the AddUpdateScreen for adding a new food entry
          Navigator.pushNamed(context, '/add');
        },
        tooltip: 'Add Food Entry',
        child: const Icon(Icons.add),
      ),
    );
  }
}
