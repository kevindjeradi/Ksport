class CompletedTraining {
  final String trainingId;
  final DateTime dateCompleted;
  final String id;

  CompletedTraining(
      {required this.trainingId,
      required this.dateCompleted,
      required this.id});

  factory CompletedTraining.fromMap(Map<String, dynamic> map) {
    return CompletedTraining(
      trainingId: map['trainingId'],
      dateCompleted: DateTime.parse(map['dateCompleted']),
      id: map['_id'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'trainingId': trainingId,
      'dateCompleted': dateCompleted.toIso8601String(),
      '_id': id,
    };
  }
}
