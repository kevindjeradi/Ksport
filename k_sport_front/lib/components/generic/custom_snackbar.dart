import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context,
  String message,
  SnackBarType type, {
  int duration = 2,
}) {
  final theme = Theme.of(context);
  Color backgroundColor;
  Color textColor;
  IconData? iconData;

  switch (type) {
    case SnackBarType.error:
      backgroundColor = theme.colorScheme.error;
      textColor = theme.colorScheme.onError;
      iconData = Icons.error_outline;
      break;
    case SnackBarType.success:
      backgroundColor = theme.colorScheme.secondaryContainer;
      textColor = theme.colorScheme.onSecondaryContainer;
      iconData = Icons.check_circle_outline;
      break;
    case SnackBarType.info:
    default:
      backgroundColor = theme.colorScheme.primary;
      textColor = theme.colorScheme.onPrimary;
      iconData = Icons.info_outline;
      break;
  }

  final snackBar = SnackBar(
    duration: Duration(seconds: duration),
    content: Row(
      children: [
        Icon(
          iconData,
          color: textColor,
          size: 20,
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Text(
            message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    margin: const EdgeInsets.all(16.0),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

enum SnackBarType { info, error, success }
