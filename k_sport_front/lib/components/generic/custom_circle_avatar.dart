import 'package:flutter/material.dart';

class CustomCircleAvatar extends StatelessWidget {
  final String imagePath;
  final double radius;
  final Color bgColor;

  const CustomCircleAvatar({
    super.key,
    required this.imagePath,
    this.radius = 80.0,
    this.bgColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (_isUrl(imagePath)) {
      imageProvider = NetworkImage(imagePath);
    } else {
      imageProvider = AssetImage(imagePath);
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: imageProvider,
      backgroundColor: bgColor,
    );
  }

  bool _isUrl(String path) {
    return Uri.tryParse(path)?.hasScheme ?? false;
  }
}
