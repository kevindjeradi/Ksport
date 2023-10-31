// Muscle.dart
class Muscle {
  final String id;
  final String imageUrl;
  final String label;
  final String detailTitle;
  final String? groupe;

  Muscle({
    required this.id,
    required this.imageUrl,
    required this.label,
    required this.detailTitle,
    this.groupe,
  });

  factory Muscle.fromJson(Map<String, dynamic> json) {
    return Muscle(
      id: json['_id'],
      imageUrl: json['imageUrl'],
      label: json['label'],
      detailTitle: json['detailTitle'],
      groupe: json['groupe'],
    );
  }
}
