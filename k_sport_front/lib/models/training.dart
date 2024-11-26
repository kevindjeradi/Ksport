class Training {
  final String id;
  final String name;
  final String description;
  final List<Map<String, dynamic>> exercises;
  final String goal;

  Training({
    required this.id,
    required this.name,
    required this.description,
    required this.exercises,
    required this.goal,
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    var exercisesList = List<Map<String, dynamic>>.from(json['exercises']);
    // Sort exercises by order if it exists, otherwise maintain the original order
    exercisesList.sort((a, b) => (a['order'] ?? exercisesList.indexOf(a))
        .compareTo(b['order'] ?? exercisesList.indexOf(b)));

    return Training(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      exercises: exercisesList,
      goal: json['goal'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'description': description,
      'exercises': exercises
          .asMap()
          .map((index, exercise) {
            exercise['order'] = index;
            return MapEntry(index, exercise);
          })
          .values
          .toList(),
      'goal': goal,
    };
  }
}
