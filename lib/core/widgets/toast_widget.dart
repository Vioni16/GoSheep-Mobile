import 'package:flutter/material.dart';

enum ToastType { success, error, warning, info }

class ToastService {
  static OverlayEntry? _entry;

  static void show(
    BuildContext context,
    String message, {
    String? title,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
  }) {
    _entry?.remove();
    _entry = null;

    _entry = OverlayEntry(
      builder: (ctx) => _ToastOverlay(
        title: title,
        message: message,
        type: type,
        duration: duration,
        onRemove: () {
          try {
            _entry?.remove();
          } catch (_) {}
          _entry = null;
        },
      ),
    );

    Overlay.of(context).insert(_entry!);
  }
}

class _ToastOverlay extends StatefulWidget {
  final String? title;
  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback onRemove;

  const _ToastOverlay({
    this.title,
    required this.message,
    required this.type,
    required this.duration,
    required this.onRemove,
  });

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _slide = Tween<Offset>(
      begin: const Offset(0, -0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(widget.duration, _dismiss);
  }

  void _dismiss() async {
    try {
      await _controller.reverse();
    } catch (_) {}
    widget.onRemove();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.35,
      left: 0,
      right: 0,
      child: IgnorePointer(
        child: Center(
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _opacity,
              child: DefaultTextStyle(
                style: const TextStyle(decoration: TextDecoration.none),
                child: Container(
                  width: 170,
                  height: 140,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.title != null) ...[
                        Text(
                          widget.title!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            decoration: TextDecoration.none,
                            decorationThickness: 0,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                      ],
                      Text(
                        widget.message,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          decoration: TextDecoration.none,
                          decorationThickness: 0,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
