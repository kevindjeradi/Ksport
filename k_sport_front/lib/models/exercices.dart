class Exercice {
  final String id;
  final String imageUrl;
  final String label;
  final String detailTitle;
  final String muscleLabel;
  final String detailDescription;
  int restTime;

  Exercice({
    required this.id,
    required this.imageUrl,
    required this.label,
    required this.detailTitle,
    required this.muscleLabel,
    required this.detailDescription,
    this.restTime = 0,
  });

  factory Exercice.fromJson(Map<String, dynamic> json) {
    return Exercice(
      id: json['_id'],
      imageUrl: json['imageUrl'],
      label: json['label'],
      detailTitle: json['detailTitle'],
      muscleLabel: json['muscleLabel'],
      detailDescription: json['detailDescription'],
    );
  }
}
