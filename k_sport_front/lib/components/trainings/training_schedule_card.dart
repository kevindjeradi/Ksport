import 'package:flutter/material.dart';
import 'package:k_sport_front/models/training.dart';

class TrainingCard extends StatefulWidget {
  final Training training;
  final bool isSelected;
  final VoidCallback onTap;

  const TrainingCard({
    super.key,
    required this.training,
    required this.isSelected,
    required this.onTap,
  });

  @override
  TrainingCardState createState() => TrainingCardState();
}

class TrainingCardState extends State<TrainingCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Card(
        elevation: widget.isSelected ? 5.0 : 1.0,
        color: widget.isSelected ? Colors.green[200] : null,
        child: Center(
          child: Text(
            widget.training.name,
            style: TextStyle(
              color: widget.isSelected
                  ? Colors.black
                  : theme.colorScheme.onBackground,
            ),
          ),
        ),
      ),
    );
  }
}
