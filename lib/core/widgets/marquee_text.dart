import 'package:flutter/material.dart';

class MarqueeText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final Duration animationDuration;
  final Duration backDuration;
  final Duration pauseDuration;

  const MarqueeText({
    super.key,
    required this.text,
    required this.style,
    this.animationDuration = const Duration(seconds: 4),
    this.backDuration = const Duration(seconds: 1),
    this.pauseDuration = const Duration(seconds: 2),
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> {
  late ScrollController _scrollController;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startScrolling());
  }

  void _startScrolling() async {
    if (_isDisposed || !_scrollController.hasClients) return;

    final maxScrollExtent = _scrollController.position.maxScrollExtent;
    if (maxScrollExtent <= 0) return;

    // Pause before scrolling
    await Future.delayed(widget.pauseDuration);
    if (_isDisposed || !_scrollController.hasClients) return;

    // Scroll to the end
    await _scrollController.animateTo(
      maxScrollExtent,
      duration: widget.animationDuration,
      curve: Curves.linear,
    );
    if (_isDisposed || !_scrollController.hasClients) return;

    // Pause at the end
    await Future.delayed(widget.pauseDuration);
    if (_isDisposed || !_scrollController.hasClients) return;

    // Scroll back to the beginning
    await _scrollController.animateTo(
      0.0,
      duration: widget.backDuration,
      curve: Curves.easeOut,
    );

    // Loop
    _startScrolling();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 1.0,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        child: Text(widget.text, style: widget.style, maxLines: 1),
      ),
    );
  }
}
