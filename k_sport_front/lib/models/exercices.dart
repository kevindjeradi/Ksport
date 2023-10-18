class Exercice {
  final String id;
  final String imageUrl;
  final String label;
  final String detailTitle;
  final String detailDescription;

  Exercice({
    required this.id,
    required this.imageUrl,
    required this.label,
    required this.detailTitle,
    required this.detailDescription,
  });

  factory Exercice.fromJson(Map<String, dynamic> json) {
    return Exercice(
      id: json['_id'],
      imageUrl: json['imageUrl'],
      label: json['label'],
      detailTitle: json['detailTitle'],
      detailDescription: json['detailDescription'],
    );
  }
}
