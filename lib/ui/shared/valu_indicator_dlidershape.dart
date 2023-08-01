import 'package:flutter/material.dart';

class ValueIndicatorThumbShape extends RoundSliderThumbShape {
  final double minValue;
  final double maxValue;

  ValueIndicatorThumbShape({this.minValue = 0, this.maxValue = 1});

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;

    // Paint the thumb circle
    super.paint(context, center,
        activationAnimation: activationAnimation,
        enableAnimation: enableAnimation,
        isDiscrete: isDiscrete,
        labelPainter: labelPainter,
        parentBox: parentBox,
        sliderTheme: sliderTheme,
        textDirection: textDirection,
        value: value,
        textScaleFactor: textScaleFactor,
        sizeWithOverflow: sizeWithOverflow);

    // Paint the value text
    final double valuePercentage =
        (value - minValue) / (maxValue - minValue) * 100;
    final String valueText = '${valuePercentage.toStringAsFixed(0)}%';
    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: valueText,
        style: sliderTheme.valueIndicatorTextStyle,
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final double textOffset = (sizeWithOverflow.width - textPainter.width) / 2;
    final Offset textPosition = Offset(center.dx - textOffset, center.dy - 6);
    textPainter.paint(canvas, textPosition);
  }
}
