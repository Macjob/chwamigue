import 'package:flutter/material.dart';
import '../models/animation_option.dart';

class AnimatedCircle extends StatefulWidget {
  final Offset position;
  final Color color;
  final AnimationOption animationType;

  const AnimatedCircle({
    super.key,
    required this.position,
    required this.color,
    required this.animationType,
  });

  @override
  State<AnimatedCircle> createState() => _AnimatedCircleState();
}

class _AnimatedCircleState extends State<AnimatedCircle> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    final curve = widget.animationType.curve;
    _animation = Tween<double>(
      begin: widget.animationType.begin,
      end: widget.animationType.end,
    ).animate(curve != null ? CurvedAnimation(parent: _controller, curve: curve) : _controller);

    _controller.forward();
  }

  @override
  void dispose() => _controller.dispose();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx - 40,
      top: widget.position.dy - 40,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: widget.color,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.black, width: 3),
              ),
            ),
          );
        },
      ),
    );
  }
}
