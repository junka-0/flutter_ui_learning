import 'dart:math';

import 'package:flutter/material.dart';

class DoubleIndicator extends StatefulWidget {
  final double width;

  final double indicatorLineHeight;
  final double indicatorLineBorderRadius;
  final Color indicatorLineBorderColor;
  final Color indicatorLineBackgroundColor;

  final Color indicatorLineActiveScaleColor;
  final List<int> indicatorScales;
  final TextStyle indicatorScalesTextStyle;
  final double indicatorActiveScale;
  final double indicatorActiveScaleAnimationValue;
  final TextStyle indicatorActiveScaleTextStyle;

  final Color indicatorLineCurrentValueColor;
  final double indicatorCurrentValue;
  final TextStyle indicatorCurrentValueTextStyle;

  final double indicatorDotRadius;
  final Color indicatorDotColor;

  final double spaceBetweenTopRowAndIndicator;
  final double spaceBetweenIndicatorAndBottomRow;

  const DoubleIndicator({
    required this.width,
    required this.indicatorLineHeight,
    required this.indicatorLineBorderRadius,
    required this.indicatorLineBorderColor,
    required this.indicatorLineBackgroundColor,
    required this.indicatorLineActiveScaleColor,
    required this.indicatorActiveScaleAnimationValue,
    required this.indicatorScales,
    required this.indicatorScalesTextStyle,
    required this.indicatorActiveScale,
    required this.indicatorActiveScaleTextStyle,
    required this.indicatorLineCurrentValueColor,
    required this.indicatorCurrentValue,
    required this.indicatorCurrentValueTextStyle,
    required this.indicatorDotRadius,
    required this.indicatorDotColor,
    this.spaceBetweenTopRowAndIndicator = 0.0,
    this.spaceBetweenIndicatorAndBottomRow = 0.0,
    Key? key,
  }) : super(key: key);

  @override
  State<DoubleIndicator> createState() => _DoubleIndicatorState();
}

class _DoubleIndicatorState extends State<DoubleIndicator>
    with TickerProviderStateMixin {
  var _topRowHeight = 0.0;
  var _indicatorHeight = 0.0;
  var _totalHeight = 0.0;

  @override
  void initState() {
    super.initState();
    _calcTotalHeight();
  }

  void _calcTotalHeight() {
    _topRowHeight = _calcTopRowHeight();
    _indicatorHeight =
        max(widget.indicatorLineHeight, widget.indicatorDotRadius * 2);
    final bottomRowHeight = _calcTextSize(
      widget.indicatorCurrentValue.toString(),
      widget.indicatorCurrentValueTextStyle,
    ).height;
    _totalHeight = _topRowHeight +
        widget.spaceBetweenTopRowAndIndicator +
        _indicatorHeight +
        widget.spaceBetweenIndicatorAndBottomRow +
        bottomRowHeight;
  }

  double _calcTopRowHeight() {
    final activeScaleTextHeight = _calcTextSize(
      widget.indicatorActiveScale.toString(),
      widget.indicatorActiveScaleTextStyle,
    ).height;

    if (widget.indicatorScales.isEmpty) return activeScaleTextHeight;

    final nomarlScaleTextHeight = _calcTextSize(
      widget.indicatorScales.first.toString(),
      widget.indicatorScalesTextStyle,
    ).height;

    return max(activeScaleTextHeight, nomarlScaleTextHeight);
  }

  // Text?????????????????????
  Size _calcTextSize(String text, TextStyle style) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    return textPainter.size;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: _totalHeight,
      child: CustomPaint(
        painter: PageIndicatorPainter(
          indicatorLineHeight: widget.indicatorLineHeight,
          indicatorLineRadius: widget.indicatorLineBorderRadius,
          indicatorLineBorderColor: widget.indicatorLineBorderColor,
          indicatorLineBackgroundColor: widget.indicatorLineBackgroundColor,
          indicatorLineActiveScaleColor: widget.indicatorLineActiveScaleColor,
          indicatorScales: widget.indicatorScales,
          indicatorScalesTextStyle: widget.indicatorScalesTextStyle,
          indicatorActiveScale: widget.indicatorActiveScale,
          indicatorActiveScaleAnimationValue:
              widget.indicatorActiveScaleAnimationValue,
          indicatorActiveScaleTextStyle: widget.indicatorActiveScaleTextStyle,
          indicatorLineCurrentValueColor: widget.indicatorLineCurrentValueColor,
          indicatorCurrentValue: widget.indicatorCurrentValue,
          indicatorCurrentValueTextStyle: widget.indicatorCurrentValueTextStyle,
          indicatorDotRadius: widget.indicatorDotRadius,
          indicatorDotColor: widget.indicatorDotColor,
          topRowHeight: _topRowHeight,
          indicatorHeight: _indicatorHeight,
          spaceBetweenTopRowAndIndicator: widget.spaceBetweenTopRowAndIndicator,
          spaceBetweenIndicatorAndBottomRow:
              widget.spaceBetweenIndicatorAndBottomRow,
        ),
      ),
    );
  }
}

class PageIndicatorPainter extends CustomPainter {
  final textPainter = TextPainter(
    textDirection: TextDirection.ltr,
    maxLines: 1,
    ellipsis: '...',
  );
  final paintInstance = Paint();

  final double indicatorLineHeight;
  final double indicatorLineRadius;
  final Color indicatorLineBorderColor;
  final Color indicatorLineBackgroundColor;
  final Color indicatorLineActiveScaleColor;
  final List<int> indicatorScales;
  final int maxScale;
  final TextStyle indicatorScalesTextStyle;
  final double indicatorActiveScale;
  final double indicatorActiveScaleAnimationValue;
  final TextStyle indicatorActiveScaleTextStyle;
  final Color indicatorLineCurrentValueColor;
  final double indicatorCurrentValue;
  final TextStyle indicatorCurrentValueTextStyle;

  final double indicatorDotRadius;
  final Color indicatorDotColor;

  final double topRowHeight;
  final double indicatorHeight;

  final double spaceBetweenTopRowAndIndicator;
  final double spaceBetweenIndicatorAndBottomRow;

  PageIndicatorPainter({
    required this.indicatorLineHeight,
    required this.indicatorLineRadius,
    required this.indicatorLineBorderColor,
    required this.indicatorLineBackgroundColor,
    required this.indicatorLineActiveScaleColor,
    required this.indicatorScales,
    required this.indicatorScalesTextStyle,
    required this.indicatorActiveScale,
    required this.indicatorActiveScaleAnimationValue,
    required this.indicatorActiveScaleTextStyle,
    required this.indicatorLineCurrentValueColor,
    required this.indicatorCurrentValue,
    required this.indicatorCurrentValueTextStyle,
    required this.indicatorDotRadius,
    required this.indicatorDotColor,
    required this.topRowHeight,
    required this.indicatorHeight,
    required this.spaceBetweenTopRowAndIndicator,
    required this.spaceBetweenIndicatorAndBottomRow,
  }) : maxScale = indicatorScales.last;

  @override
  void paint(Canvas canvas, Size size) {
    // ??????????????????????????????????????????(???CurrentValue??????0???????????????????????????????????????????????????)
    canvas.translate(indicatorDotRadius, 0.0);

    // ??????????????????????????????????????????
    final indicatorWidth = _calcIndicatorWidth(size);

    // ???????????????????????????????????????????????????
    final lineVerticalPosition = topRowHeight +
        spaceBetweenTopRowAndIndicator +
        indicatorDotRadius -
        indicatorLineHeight / 2;

    // ??????????????????????????????????????????
    _drawIndicatorLineBackground(canvas, indicatorWidth, lineVerticalPosition);

    // ??????????????????
    final length = indicatorScales.length;
    // ?????????????????????????????????
    for (var i = 0; i < length; i++) {
      // ????????????????????????????????????
      final scale = indicatorScales[i];
      // ???????????????????????????????????????????????????
      final horizontalPosition = scale / maxScale * indicatorWidth;

      // ????????????????????????????????????????????? (???????????????0)
      final lastScale = i == 0 ? scale - 1 : indicatorScales[i - 1];

      // ???????????????????????????????????????
      _drawScaleText(
        canvas,
        horizontalPosition,
        scale,
      );
    }

    // ????????????????????????????????????????????????????????????????????????
    _drawIndicatorActiveScaleLine(
      canvas,
      lineVerticalPosition,
      indicatorActiveScaleAnimationValue / maxScale * indicatorWidth,
    );

    // ???CurrentValue????????????
    final currentValueHorizontalPosition =
        indicatorCurrentValue / maxScale * indicatorWidth;

    // ???????????????????????????????????????
    _drawIndicatorCurrentValueLine(
        canvas, currentValueHorizontalPosition, lineVerticalPosition);

    // ???CurrentValue????????????
    _drawcurrentValueText(canvas, currentValueHorizontalPosition);

    // ????????????????????????????????????
    _drawIndicatorBorder(canvas, indicatorWidth, lineVerticalPosition);

    // ???????????????????????????????????????????????????
    _drawCurrentValueDot(
        canvas, currentValueHorizontalPosition, lineVerticalPosition);
  }

  double _calcIndicatorWidth(Size size) {
    textPainter.text = TextSpan(
      text: maxScale.toString(),
      style: indicatorScalesTextStyle,
    );
    textPainter.layout();
    return size.width - textPainter.size.width / 2 - indicatorDotRadius;
  }

  void _drawIndicatorLineBackground(
    Canvas canvas,
    double wholeWidth,
    double lineVerticalPosition,
  ) {
    paintInstance
      ..strokeWidth = 1.0
      ..color = indicatorLineBackgroundColor
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(
      0.0,
      lineVerticalPosition,
      wholeWidth,
      indicatorLineHeight,
    );
    final rRect = BorderRadius.circular(indicatorLineRadius).toRRect(rect);

    canvas.drawRRect(rRect, paintInstance);
  }

  void _drawScaleText(
    Canvas canvas,
    double horizontalPosition,
    int scale,
  ) {
    textPainter.text = TextSpan(
      text: scale.toString(),
      style: scale == indicatorActiveScale
          ? indicatorActiveScaleTextStyle
          : indicatorScalesTextStyle,
    );
    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        horizontalPosition - textPainter.size.width / 2,
        (topRowHeight / 2) - (textPainter.size.height / 2),
      ),
    );
  }

  void _drawIndicatorActiveScaleLine(
    Canvas canvas,
    double lineVerticalPosition,
    double horizontalPosition,
  ) {
    paintInstance
      ..color = indicatorLineActiveScaleColor
      ..style = PaintingStyle.fill;
    final rect = Rect.fromLTWH(
      0.0,
      lineVerticalPosition,
      horizontalPosition,
      indicatorLineHeight,
    );
    final rRect = BorderRadius.circular(indicatorLineRadius).toRRect(rect);

    canvas.drawRRect(rRect, paintInstance);
  }

  void _drawIndicatorCurrentValueLine(
    Canvas canvas,
    double currentValueHorizontalPosition,
    double lineVerticalPosition,
  ) {
    paintInstance.color = indicatorLineCurrentValueColor;
    final rect = Rect.fromLTWH(
      0.0,
      lineVerticalPosition,
      currentValueHorizontalPosition,
      indicatorLineHeight,
    );
    final rRect = BorderRadius.circular(indicatorLineRadius).toRRect(rect);
    canvas.drawRRect(rRect, paintInstance);
  }

  void _drawcurrentValueText(
    Canvas canvas,
    double currentValueHorizontalPosition,
  ) {
    textPainter.text = TextSpan(
      text: indicatorCurrentValue.toInt().toString(),
      style: indicatorCurrentValueTextStyle,
    );
    textPainter.layout();

    textPainter.paint(
      canvas,
      Offset(
        currentValueHorizontalPosition - textPainter.size.width / 2,
        topRowHeight +
            spaceBetweenTopRowAndIndicator +
            indicatorHeight +
            spaceBetweenIndicatorAndBottomRow,
      ),
    );
  }

  void _drawIndicatorBorder(
    Canvas canvas,
    double wholeWidth,
    double lineVerticalPosition,
  ) {
    paintInstance
      ..color = indicatorLineBorderColor
      ..style = PaintingStyle.stroke;
    final rect = Rect.fromLTWH(
        0.0, lineVerticalPosition, wholeWidth, indicatorLineHeight);
    final rRect = BorderRadius.circular(indicatorLineRadius).toRRect(rect);
    canvas.drawRRect(rRect, paintInstance);
  }

  void _drawCurrentValueDot(
    Canvas canvas,
    double currentValueHorizontalPosition,
    double lineVerticalPosition,
  ) {
    paintInstance
      ..color = indicatorLineCurrentValueColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(
        currentValueHorizontalPosition,
        lineVerticalPosition + indicatorLineHeight / 2,
      ),
      indicatorDotRadius,
      paintInstance,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
