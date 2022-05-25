import 'package:flutter/material.dart';

class GridCard extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double aspectRatio;
  final bool rounded;
  final int? alpha;

  const GridCard({
    Key? key,
    this.alpha,
    this.backgroundColor = const Color(0xFFFFF8E1),
    this.aspectRatio = 1,
    required this.child,
    this.rounded = false,
  }) : super(key: key);

  BorderRadius get roundedRadius {
    return rounded
        ? BorderRadius.all(Radius.circular(90))
        : BorderRadius.all(Radius.circular(20));
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: roundedRadius,
          ),
          elevation: 8,
          color: alpha != null
              ? backgroundColor.withAlpha(alpha!)
              : backgroundColor,
          child: ClipRRect(
            borderRadius: roundedRadius,
            child: child,
          ),
        ),
      ),
    );
  }
}

class GridCardButton extends StatelessWidget {
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;
  final bool enabled;
  final Widget icon;
  final Color backgroundColor;
  final Color iconColor;
  final bool rounded;
  final int alpha;

  const GridCardButton({
    Key? key,
    required this.alpha,
    this.rounded = true,
    required this.onLongPress,
    required this.onTap,
    this.enabled = false,
    required this.icon,
    this.backgroundColor = const Color(0xFFFFF8E1),
    this.iconColor = Colors.green,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
        tween: IntTween(begin: 255, end: alpha),
        duration: const Duration(milliseconds: 200),
        builder: (context, alpha, child) {
          return GridCard(
            alpha: alpha,
            rounded: rounded,
            child: InkWell(
              borderRadius: BorderRadius.all(Radius.circular(90)),
              onTap: onTap,
              onLongPress: onLongPress,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: FittedBox(
                  fit: BoxFit.fitHeight,
                  child: Theme(
                    child: icon,
                    data: Theme.of(context).copyWith(
                      iconTheme: Theme.of(context).iconTheme.copyWith(
                            color:
                                enabled ? iconColor : Colors.blueGrey.shade800,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
