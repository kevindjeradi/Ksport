import 'package:flutter/material.dart';

class MuscleGroupList extends StatelessWidget {
  final Function(String) onGroupSelected;

  MuscleGroupList({super.key, required this.onGroupSelected});

  final Map<String, String> groupImages = {
    "Jambes": "assets/images/muscles/groupes/Jambes.png",
    "Bras": "assets/images/muscles/groupes/Bras.png",
    "Dos": "assets/images/muscles/groupes/Dos.png",
    "Torse": "assets/images/muscles/groupes/Torse.png",
  };

  @override
  Widget build(BuildContext context) {
    final List<String> groups = ["Jambes", "Bras", "Dos", "Torse"];
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        height: 130,
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: groups.length,
          itemBuilder: (context, index) {
            return Container(
              width: 120,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton(
                onPressed: () => onGroupSelected(groups[index]),
                style: ElevatedButton.styleFrom(
                  foregroundColor: theme.colorScheme.onSurface,
                  backgroundColor: theme.colorScheme.surface,
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4,
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Ink.image(
                      image: AssetImage(groupImages[groups[index]]!),
                      fit: BoxFit.cover,
                      child: Container(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        groups[index],
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
