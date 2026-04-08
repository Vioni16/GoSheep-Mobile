import 'package:flutter/material.dart';

class FloatingLogo extends StatefulWidget {
  final double height;
  const FloatingLogo({super.key, this.height = 15});

  @override
  State<FloatingLogo> createState() => _FloatingLogoState();
}

class _FloatingLogoState extends State<FloatingLogo> with SingleTickerProviderStateMixin{
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: widget.height)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -_animation.value),
          child: Transform.scale(
            scale: 1 + (_animation.value / 100),
            child: child,
          ),
        );
      },
      child: Image.asset("assets/images/logo.png"),
    );
  }
}
