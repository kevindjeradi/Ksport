class Workout {
  final int id;
  final String imageUrl;
  final String label;
  final String detailTitle;
  final String detailDescription;

  Workout({
    required this.id,
    required this.imageUrl,
    required this.label,
    required this.detailTitle,
    required this.detailDescription,
  });

  factory Workout.fromJson(Map<String, dynamic> json) {
    return Workout(
      id: json['id'],
      imageUrl: json['imageUrl'],
      label: json['label'],
      detailTitle: json['detailTitle'],
      detailDescription: json['detailDescription'],
    );
  }
}
