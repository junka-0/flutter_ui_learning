import 'package:flutter/material.dart';
import 'package:flutter_ui_learning/component/bounce_rect_painter.dart';

class BounceAnimationScreen extends StatefulWidget {
  const BounceAnimationScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<BounceAnimationScreen> createState() => _BounceAnimationScreenState();
}

class _BounceAnimationScreenState extends State<BounceAnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  void repeatAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0).animate(_animationController)
      ..addStatusListener(
        (status) {
          if (status == AnimationStatus.completed) {
            Future.delayed(
              const Duration(seconds: 3),
              () {
                _animationController.reset();
                _animationController.forward();
              },
            );
          }
        },
      );
    _animationController.forward();
  }

  @override
  void initState() {
    super.initState();
    repeatAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 320,
              height: 60,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: BounceRectPainter(
                      controllerValue: _animation.value,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
