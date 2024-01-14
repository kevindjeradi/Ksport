import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String position;

  const CustomAppBar(
      {super.key, required this.title, this.position = 'center'});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    switch (position) {
      case 'center':
        return AppBar(
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.onBackground,
          elevation: 0,
          centerTitle: true,
          title: Text(title, style: theme.textTheme.displaySmall),
        );
      case 'left':
        return AppBar(
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.onBackground,
          elevation: 0,
          centerTitle: false,
          title: Text(title, style: theme.textTheme.displaySmall),
        );
      case 'right':
        return AppBar(
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.onBackground,
          elevation: 0,
          centerTitle: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(title, style: theme.textTheme.displaySmall),
            ],
          ),
        );

      default:
        return AppBar(
          backgroundColor: theme.colorScheme.background,
          foregroundColor: theme.colorScheme.onBackground,
          elevation: 0,
          centerTitle: true,
          title: Text(title, style: theme.textTheme.displaySmall),
        );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
