import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  final bool isEditable;

  const InfoRow({
    Key? key,
    required this.label,
    required this.value,
    this.onTap,
    this.isEditable = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: theme.textTheme.titleLarge),
            ),
            if (isEditable)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit,
                      size: 18, color: theme.colorScheme.onBackground),
                  const SizedBox(width: 4),
                  Text(value, style: theme.textTheme.headlineSmall),
                ],
              )
            else
              Text(value, style: theme.textTheme.headlineSmall),
          ],
        ),
      ),
    );
  }
}
