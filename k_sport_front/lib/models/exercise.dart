class Exercise {
  final String id;
  final String imageUrl;
  final String label;
  final String detailTitle;
  final String muscleLabel;
  final String detailDescription;
  int restTime;

  Exercise({
    required this.id,
    required this.imageUrl,
    required this.label,
    required this.detailTitle,
    required this.muscleLabel,
    required this.detailDescription,
    this.restTime = 0,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['_id'],
      imageUrl: json['imageUrl'],
      label: json['label'],
      detailTitle: json['detailTitle'],
      muscleLabel: json['muscleLabel'],
      detailDescription: json['detailDescription'],
    );
  }
}
