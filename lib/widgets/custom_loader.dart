import 'package:flutter/material.dart';

class CustomDotLoader extends StatefulWidget {
  const CustomDotLoader({super.key});

  @override
  State<CustomDotLoader> createState() => _CustomDotLoaderState();
}

class _CustomDotLoaderState extends State<CustomDotLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _Dot(
              color: Colors.red.shade900, // Dark Red
              controller: _controller,
              delay: 0.0,
            ),
            _Dot(
              color: Colors.red.shade700, // Medium Red
              controller: _controller,
              delay: 0.2,
            ),
            _Dot(
              color: Colors.redAccent, // Bright Red
              controller: _controller,
              delay: 0.4,
            ),
            _Dot(
              color: Colors.red.shade200, // Light Red
              controller: _controller,
              delay: 0.6,
            ),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  final Color color;
  final AnimationController controller;
  final double delay;

  const _Dot({
    required this.color,
    required this.controller,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        final double t = (controller.value - delay + 1) % 1;
        final double scale =
            1.0 + 0.3 * (0.5 - (t - 0.5).abs()) * 2; // Pulse effect
        final double opacity =
            0.6 + 0.4 * (0.5 - (t - 0.5).abs()) * 2; // Fade effect

        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
          ),
        );
      },
    );
  }
}
