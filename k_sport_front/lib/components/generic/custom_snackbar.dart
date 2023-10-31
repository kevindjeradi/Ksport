import 'package:flutter/material.dart';

void showCustomSnackBar(
    BuildContext context, String message, SnackBarType type) {
  final theme = Theme.of(context);
  Color backgroundColor;
  Color textColor;

  switch (type) {
    case SnackBarType.error:
      backgroundColor = theme.colorScheme.error;
      textColor = theme.colorScheme.onError;
      break;
    case SnackBarType.success:
      backgroundColor = theme.colorScheme.secondary;
      textColor = theme.colorScheme.onSecondary;
      break;
    case SnackBarType.info:
    default:
      backgroundColor = theme.colorScheme.secondaryContainer;
      textColor = theme.colorScheme.onSurface;
      break;
  }

  final snackBar = SnackBar(
    duration: const Duration(seconds: 1),
    content: Text(
      message,
      style: TextStyle(
        color: textColor,
        fontSize: 16.0,
      ),
    ),
    backgroundColor: backgroundColor,
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
    ),
    margin: const EdgeInsets.all(16.0),
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

enum SnackBarType { info, error, success }
