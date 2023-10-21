class Training {
  final String id;
  final String name;
  final String description;
  final int restTime;

  Training(
      {required this.id,
      required this.name,
      required this.description,
      required this.restTime});

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      restTime: json['restTime'],
    );
  }
}
