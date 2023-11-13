// In completed_training.dart
class CompletedTraining {
  final String trainingId;
  final DateTime dateCompleted;
  final String name;
  final String description;
  final List<TrainingExercise> exercises;
  final String goal;

  CompletedTraining({
    required this.trainingId,
    required this.dateCompleted,
    required this.name,
    required this.description,
    required this.exercises,
    required this.goal,
  });

  factory CompletedTraining.fromMap(Map<String, dynamic> map) {
    return CompletedTraining(
      trainingId: map['_id'] ?? 'default-training-id',
      dateCompleted: map['dateCompleted'] != null
          ? DateTime.parse(map['dateCompleted'])
          : DateTime.now(),
      name: map['trainingData']['name'] ?? 'Default Name',
      description: map['trainingData']['description'] ?? 'Default Description',
      exercises: (map['trainingData']['exercises'] as List? ?? [])
          .map((e) => TrainingExercise.fromMap(e as Map<String, dynamic>))
          .toList(),
      goal: map['trainingData']['goal'] ?? 'Default Goal',
    );
  }
}

class TrainingExercise {
  final String label;
  final String exerciseId;
  final List<int> repetitions;
  final int sets;
  final List<int> weight;
  final List<int> restTime;

  TrainingExercise({
    required this.label,
    required this.exerciseId,
    required this.repetitions,
    required this.sets,
    required this.weight,
    required this.restTime,
  });

  factory TrainingExercise.fromMap(Map<String, dynamic> map) {
    return TrainingExercise(
      label: map['label'] ?? 'Default Label',
      exerciseId: map['exerciseId'] ?? 'default-exercise-id',
      repetitions: List<int>.from(map['repetitions'] ?? []),
      sets: map['sets'] ?? 0,
      weight: List<int>.from(map['weight'] ?? []),
      restTime: List<int>.from(map['restTime'] ?? []),
    );
  }
}
