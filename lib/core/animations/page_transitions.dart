import 'package:flutter/material.dart';

class PageTransitions {
  static const Duration _duration = Duration(milliseconds: 300);

  /// Slide transition from right to left (like iOS)
  static Route<T> slideTransition<T extends Object?>(
    Widget page, {
    Duration duration = _duration,
    Offset begin = const Offset(1.0, 0.0),
    Offset end = Offset.zero,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final slideAnimation = animation.drive(
          Tween(begin: begin, end: end).chain(
            CurveTween(curve: Curves.easeInOutCubic),
          ),
        );

        final fadeAnimation = animation.drive(
          Tween(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: Curves.easeIn),
          ),
        );

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Fade transition with scale effect
  static Route<T> fadeScaleTransition<T extends Object?>(
    Widget page, {
    Duration duration = _duration,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final fadeAnimation = animation.drive(
          Tween(begin: 0.0, end: 1.0).chain(
            CurveTween(curve: Curves.easeInOut),
          ),
        );

        final scaleAnimation = animation.drive(
          Tween(begin: 0.95, end: 1.0).chain(
            CurveTween(curve: Curves.easeInOut),
          ),
        );

        return FadeTransition(
          opacity: fadeAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: child,
          ),
        );
      },
    );
  }

  /// Hero-style shared element transition
  static Route<T> sharedAxisTransition<T extends Object?>(
    Widget page, {
    Duration duration = _duration,
    SharedAxisTransitionType transitionType = SharedAxisTransitionType.scaled,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transitionType) {
          case SharedAxisTransitionType.horizontal:
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0.3, 0.0), end: Offset.zero).chain(
                  CurveTween(curve: Curves.easeInOutCubic),
                ),
              ),
              child: FadeTransition(
                opacity: animation.drive(
                  CurveTween(curve: Curves.easeIn),
                ),
                child: child,
              ),
            );
          case SharedAxisTransitionType.vertical:
            return SlideTransition(
              position: animation.drive(
                Tween(begin: const Offset(0.0, 0.3), end: Offset.zero).chain(
                  CurveTween(curve: Curves.easeInOutCubic),
                ),
              ),
              child: FadeTransition(
                opacity: animation.drive(
                  CurveTween(curve: Curves.easeIn),
                ),
                child: child,
              ),
            );
          case SharedAxisTransitionType.scaled:
            return ScaleTransition(
              scale: animation.drive(
                Tween(begin: 0.8, end: 1.0).chain(
                  CurveTween(curve: Curves.easeInOutCubic),
                ),
              ),
              child: FadeTransition(
                opacity: animation.drive(
                  CurveTween(curve: Curves.easeIn),
                ),
                child: child,
              ),
            );
        }
      },
    );
  }
}

enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
}
