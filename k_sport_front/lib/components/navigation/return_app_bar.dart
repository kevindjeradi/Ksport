import 'package:flutter/material.dart';

class ReturnAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String barTitle;

  const ReturnAppBar({
    Key? key,
    required this.barTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.background,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back_ios_new,
          color: theme.colorScheme.onBackground,
        ),
      ),
      title: Text(
        barTitle,
        style: theme.textTheme.headlineMedium
            ?.copyWith(color: theme.colorScheme.onBackground),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
