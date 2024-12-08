class CardioFieldConfig {
  final bool required;
  final String label;
  final String? helperText;
  final bool isDecimal;

  const CardioFieldConfig({
    required this.label,
    this.required = false,
    this.helperText,
    this.isDecimal = false,
  });
}

final Map<String, Map<String, CardioFieldConfig>> cardioFieldsConfig = {
  'Vélo': {
    'calories': const CardioFieldConfig(
      label: 'Calories dépensées (kcal)',
      required: true,
    ),
    'averageWatts': const CardioFieldConfig(
      label: 'Puissance moyenne (watts)',
      required: true,
    ),
    'distance': const CardioFieldConfig(
      label: 'Distance (km)',
      required: true,
      isDecimal: true,
    ),
    'cadence': const CardioFieldConfig(
      label: 'Cadence moyenne (rpm)',
      helperText: 'Optionnel',
      isDecimal: true,
    ),
    'averageSpeed': const CardioFieldConfig(
      label: 'Vitesse moyenne (km/h)',
      isDecimal: true,
      helperText: 'Optionnel',
    ),
    'averageBpm': const CardioFieldConfig(
      label: 'BPM moyen',
      helperText: 'Optionnel',
    ),
    'maxBpm': const CardioFieldConfig(
      label: 'BPM max',
      helperText: 'Optionnel',
    ),
  },
  'Rameur': {
    'calories': const CardioFieldConfig(
      label: 'Calories dépensées (kcal)',
      required: true,
    ),
    'distance': const CardioFieldConfig(
      label: 'Distance (m)',
      required: true,
      isDecimal: true,
    ),
    'averageWatts': const CardioFieldConfig(
      label: 'Puissance moyenne (watts)',
      required: true,
    ),
    'split500m': const CardioFieldConfig(
      label: 'Split /500m moyen',
      helperText: 'Format: mm:ss',
      required: true,
    ),
    'strokesPerMinute': const CardioFieldConfig(
      label: 'Coups par minute moyen',
      helperText: 'Optionnel',
    ),
  },
  'Escalier': {
    'calories': const CardioFieldConfig(
      label: 'Calories dépensées (kcal)',
      required: true,
    ),
    'floors': const CardioFieldConfig(
      label: 'Étages',
      required: true,
    ),
    'averageBpm': const CardioFieldConfig(
      label: 'BPM moyen',
      helperText: 'Optionnel',
    ),
    'maxBpm': const CardioFieldConfig(
      label: 'BPM max',
      helperText: 'Optionnel',
    ),
  },
  'Course': {
    'calories': const CardioFieldConfig(
      label: 'Calories dépensées (kcal)',
      required: true,
    ),
    'distance': const CardioFieldConfig(
      label: 'Distance (km)',
      required: true,
      isDecimal: true,
    ),
    'averageSpeed': const CardioFieldConfig(
      label: 'Vitesse moyenne (km/h)',
      required: true,
      isDecimal: true,
    ),
    'averagePace': const CardioFieldConfig(
      label: 'Allure moyenne (min/km)',
      helperText: 'Format: mm:ss',
      required: true,
    ),
    'averageBpm': const CardioFieldConfig(
      label: 'BPM moyen',
      helperText: 'Optionnel',
    ),
    'maxBpm': const CardioFieldConfig(
      label: 'BPM max',
      helperText: 'Optionnel',
    ),
  },
};
