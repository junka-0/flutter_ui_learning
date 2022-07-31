import 'dart:math';

import 'package:flutter/material.dart';

class BounceRectPainter extends CustomPainter {
  static const rectWidth = 18.0;
  static const rectHeight = 13.0;

  static Path createPath() {
    const x1 = 20.0;
    const y1 = -20.0;
    const x2 = 40.0;
    const y2 = 10.0;
    final path = Path();
    path.moveTo(0, y2);
    path.quadraticBezierTo(x1, y1, x2, y2);
    path.quadraticBezierTo(x1 + x2, y1, x2 * 2, y2);
    path.quadraticBezierTo(x1 + x2 * 2, y1, x2 * 3, y2);
    path.quadraticBezierTo(x1 + x2 * 3, y1, x2 * 4, y2);
    path.quadraticBezierTo(x1 + x2 * 4, y1, x2 * 5, y2);
    path.quadraticBezierTo(x1 + x2 * 5, y1, x2 * 6, y2);
    path.quadraticBezierTo(x1 + x2 * 6, y1, x2 * 7, y2);
    return path;
  }

  BounceRectPainter({
    required this.controllerValue,
  });

  final double controllerValue;
  final Path path = createPath();
  final myPaint = Paint()..color = const Color(0xFF6581CA);

  @override
  void paint(Canvas canvas, Size size) {
    final currentOffset = _calcCurrentOffset();

    final rect = Rect.fromLTWH(
      currentOffset.dx,
      currentOffset.dy,
      rectWidth,
      rectHeight,
    );

    drawRotated(
      canvas,
      centerOffset: Offset(
        currentOffset.dx + rectWidth / 2,
        currentOffset.dy + rectHeight / 2,
      ),
      angle: pi * controllerValue,
      rect: rect,
    );
  }

  Offset _calcCurrentOffset() {
    final pathMetrics = path.computeMetrics();
    final pathMetric = pathMetrics.elementAt(0);
    final pos =
        pathMetric.getTangentForOffset(pathMetric.length * controllerValue);
    return pos!.position;
  }

  void drawRotated(
    Canvas canvas, {
    required Offset centerOffset,
    required double angle,
    required Rect rect,
  }) {
    canvas.save();
    canvas.translate(centerOffset.dx, centerOffset.dy);
    canvas.rotate(angle);
    canvas.translate(-centerOffset.dx, -centerOffset.dy);
    canvas.drawRect(rect, myPaint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(BounceRectPainter oldDelegate) {
    return oldDelegate.controllerValue != controllerValue;
  }
}
