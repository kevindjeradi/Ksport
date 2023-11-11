import 'package:flutter/material.dart';
import 'dart:math';

enum LoaderType { circular, linear, dots }

class CustomLoader extends StatelessWidget {
  final LoaderType? loaderType;
  final double? size;
  final Color? color;
  final Duration? duration;

  const CustomLoader(
      {Key? key, this.loaderType, this.size, this.color, this.duration})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoaderType finalLoaderType = loaderType ??
        LoaderType.values[Random().nextInt(LoaderType.values.length)];
    Color loaderColor = color ?? Theme.of(context).colorScheme.secondary;
    double loaderSize = size ?? 50.0;
    Duration animationDuration = duration ?? const Duration(milliseconds: 1000);

    switch (finalLoaderType) {
      case LoaderType.circular:
        return Center(
          child: SizedBox(
            width: loaderSize,
            height: loaderSize,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              backgroundColor: loaderColor.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
            ),
          ),
        );
      case LoaderType.linear:
        return Center(
          child: Container(
            height: 5,
            width: loaderSize * 2,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: LinearProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
              backgroundColor: loaderColor.withOpacity(0.3),
            ),
          ),
        );
      case LoaderType.dots:
        return Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: AnimatedDot(
                  color: loaderColor,
                  position: index,
                  size: loaderSize / 5,
                  duration: animationDuration,
                ),
              ),
            ),
          ),
        );
      default:
        return Center(
          child: SizedBox(
            width: loaderSize,
            height: loaderSize,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(loaderColor),
            ),
          ),
        );
    }
  }
}

class AnimatedDot extends StatefulWidget {
  final Color color;
  final int position;
  final double size;
  final Duration duration;

  const AnimatedDot(
      {Key? key,
      required this.color,
      required this.position,
      required this.size,
      required this.duration})
      : super(key: key);

  @override
  AnimatedDotState createState() => AnimatedDotState();
}

class AnimatedDotState extends State<AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          0.2 * widget.position,
          0.2 * widget.position + 0.6,
          curve: Curves.easeInOut,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: SizedBox(
        height: widget.size,
        width: widget.size,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
