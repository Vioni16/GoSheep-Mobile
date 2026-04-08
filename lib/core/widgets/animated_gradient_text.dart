import 'package:flutter/material.dart';

class AnimatedGradientText extends StatefulWidget {
  final String text;
  final List<Color> colors;
  final TextStyle? style;
  final Duration duration;

  const AnimatedGradientText(
      this.text,{
        super.key,
        required this.colors,
        this.style,
        this.duration = const Duration(seconds: 2),
      });

  @override
  State<AnimatedGradientText> createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        vsync: this,
        duration: widget.duration
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final value = _controller.value * 2;
          return ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (bounds) {
              return LinearGradient(
                  tileMode: TileMode.mirror,
                  begin: Alignment(-1 + value, 0),
                  end: Alignment(value, 0),
                  colors: widget.colors
              ).createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              );
            },
            child: Text(
              widget.text,
              style: widget.style,
            ),
          );
        }
    );
  }
}
