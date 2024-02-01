import 'package:flutter/material.dart';

class CustomNavigation {
  static Future<T?> push<T extends Object?>(BuildContext context, Widget page) {
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);
          return SlideTransition(position: offsetAnimation, child: child);
        },
      ),
    );
  }

  static Future<T?> pushReplacement<T extends Object?, TO extends Object?>(
      BuildContext context, Widget page) {
    return Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const beginNewPage = Offset(1.0, 0.0);
          const endNewPage = Offset.zero;
          const curve = Curves.easeInOut;
          var tweenNewPage = Tween(begin: beginNewPage, end: endNewPage)
              .chain(CurveTween(curve: curve));
          var offsetAnimationNewPage = animation.drive(tweenNewPage);

          const beginCurrentPage = Offset.zero;
          const endCurrentPage = Offset(-1.0, 0.0);
          var tweenCurrentPage =
              Tween(begin: beginCurrentPage, end: endCurrentPage)
                  .chain(CurveTween(curve: curve));
          var offsetAnimationCurrentPage =
              secondaryAnimation.drive(tweenCurrentPage);

          return Stack(
            children: [
              SlideTransition(
                  position: offsetAnimationCurrentPage, child: child),
              SlideTransition(position: offsetAnimationNewPage, child: page),
            ],
          );
        },
      ),
    );
  }
}
