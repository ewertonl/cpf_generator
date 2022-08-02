import 'package:flutter/material.dart';

class AnimatedCpfText extends StatelessWidget {
  const AnimatedCpfText({
    super.key,
    required this.cpfDigits,
    this.isMasked = true,
    this.fontSize = 27,
    this.onEnd,
  });

  final void Function()? onEnd;

  final List<int> cpfDigits;
  final Duration _duration = const Duration(milliseconds: 800);
  final Curve _curve = Curves.easeInOut;

  final double fontSize;
  final bool isMasked;

  @override
  Widget build(BuildContext context) {
    final List<Widget> cpfDigitWidgets = cpfDigits.map((digit) {
      return _AnimatedCPFDigit(
        digit: digit,
        curve: _curve,
        duration: _duration,
        textSize: Size(fontSize * 0.6, fontSize),
        callback: onEnd,
      );
    }).toList();

    return DefaultTextStyle(
      style: TextStyle(
        fontFamily: 'monospace',
        fontSize: 27,
        color: Theme.of(context).colorScheme.onSurface,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...cpfDigitWidgets.getRange(0, 3),
          if (isMasked) const Text("."),
          ...cpfDigitWidgets.getRange(3, 6),
          if (isMasked) const Text("."),
          ...cpfDigitWidgets.getRange(6, 9),
          if (isMasked) const Text("-"),
          ...cpfDigitWidgets.getRange(9, 11),
        ],
      ),
    );
  }
}

class _AnimatedCPFDigit extends StatelessWidget {
  const _AnimatedCPFDigit({
    required this.digit,
    required this.curve,
    required this.duration,
    required this.textSize,
    this.callback,
  });

  final void Function()? callback;

  final int digit;
  final Duration duration;
  final Curve curve;
  final Size textSize;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      onEnd: callback,
      tween: Tween<double>(end: digit.toDouble()),
      curve: curve,
      duration: duration,
      builder: (
        BuildContext context,
        double animationValue,
        Widget? child,
      ) {
        int animationDigit = animationValue.truncate();
        double animationDirection = animationValue - animationDigit;
        double textWidth = textSize.width;
        double textHeight = textSize.height;

        int currentDigit = animationDigit;
        int nextDigit = (animationDigit + 1) % 10;

        return SizedBox(
          width: textWidth,
          height: textHeight,
          child: Stack(
            children: [
              _CpfDigit(
                cpfDigit: nextDigit,
                offset: Offset(
                  (textWidth * animationDirection) - textWidth,
                  (textHeight * animationDirection) - textHeight,
                ),
              ),
              _CpfDigit(
                cpfDigit: currentDigit,
                offset: Offset(
                  textWidth * animationDirection,
                  textHeight * animationDirection,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CpfDigit extends StatelessWidget {
  const _CpfDigit({
    required this.cpfDigit,
    required this.offset,
  });

  final int cpfDigit;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: offset.dy,
      child: Text('$cpfDigit'),
    );
  }
}
