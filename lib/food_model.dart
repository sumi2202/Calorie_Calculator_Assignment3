class Food {
  int id;
  String name;
  double calories;
  DateTime date;

  Food({
    required this.id,
    required this.name,
    required this.calories,
    required this.date,
  });

  // Constructor for creating a Food object from a Map
  Food.fromMap(Map<String, dynamic> map)
      : id = map['id'],
        name = map['name'],
        calories = map['calories'],
        date = DateTime.parse(map['date']); // Parse the date from the map

  // Method to convert Food object to a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'calories': calories,
      'date': date.toIso8601String(), // Convert DateTime to ISO 8601 string
    };
  }
}

