import 'package:flutter/material.dart';
import 'dart:math';

enum LoaderType { circular, linear, dots }

class CustomLoader extends StatelessWidget {
  final LoaderType? loaderType;

  const CustomLoader({Key? key, this.loaderType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoaderType finalLoaderType = loaderType ??
        LoaderType.values[Random().nextInt(LoaderType.values.length)];
    Color loaderColor = Theme.of(context).colorScheme.secondary;

    switch (finalLoaderType) {
      case LoaderType.circular:
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
        );
      case LoaderType.linear:
        return LinearProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
          backgroundColor: loaderColor.withOpacity(0.3),
        );
      case LoaderType.dots:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            3,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: SizedBox(
                height: 20.0,
                width: 20.0,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: loaderColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        );
      default:
        return CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
        );
    }
  }
}
