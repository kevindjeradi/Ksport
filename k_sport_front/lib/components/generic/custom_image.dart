import 'package:flutter/material.dart';
import 'package:k_sport_front/components/generic/custom_loader.dart';
import 'package:k_sport_front/components/generic/custom_snackbar.dart';

class CustomImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const CustomImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return _isUrl(imagePath)
        ? Image.network(
            imagePath,
            width: width,
            height: height,
            fit: fit,
            loadingBuilder: loadingBuilder ?? _defaultLoadingBuilder,
            errorBuilder: errorBuilder ??
                (context, error, stackTrace) =>
                    _defaultErrorBuilder(context, error, stackTrace),
          )
        : Image(
            image: AssetImage(imagePath),
            width: width,
            height: height,
            fit: fit,
          );
  }

  bool _isUrl(String path) {
    return Uri.tryParse(path)?.hasScheme ?? false;
  }

  Widget _defaultLoadingBuilder(
      BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;
    return const Center(child: CustomLoader());
  }

  Widget _defaultErrorBuilder(
      BuildContext context, Object error, StackTrace? stackTrace) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showCustomSnackBar(
          context, 'Une image n\'a pas pu être chargée', SnackBarType.error);
    });
    return const Icon(Icons.error);
  }
}
