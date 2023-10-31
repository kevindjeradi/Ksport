import 'package:flutter/material.dart';

class MuscleGroupList extends StatelessWidget {
  final Function(String) onGroupSelected;

  const MuscleGroupList({super.key, required this.onGroupSelected});

  @override
  Widget build(BuildContext context) {
    final List<String> groups = ["Jambes", "Bras", "Dos", "Abdomen"];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: groups.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: OutlinedButton(
              onPressed: () => onGroupSelected(groups[index]),
              child: Text(groups[index]),
            ),
          );
        },
      ),
    );
  }
}
