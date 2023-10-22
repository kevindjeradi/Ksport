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
    return Training(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      exercises: List<Map<String, dynamic>>.from(json['exercises']),
      goal: json['goal'],
    );
  }
}
