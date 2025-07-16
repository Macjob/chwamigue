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
  final bool _hasAnimated = false;

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
      left: widget.position.dx - 25,
      top: widget.position.dy - 25,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Container(
              width: 50 * _animation.value,
              height: 50 * _animation.value,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
            );
          },
        ),
      ),
    );
  }
}

class AnimationScreen extends StatelessWidget {
  final Map<int, TouchData> activeTouches;
  final AnimationOption selectedAnimation;

  const AnimationScreen({
    super.key,
    required this.activeTouches,
    required this.selectedAnimation,
  });

  void _handleTouch(PointerEvent event, {bool isUp = false}) {
    print('Touch: ${event.position}');
    // Handle touch events
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Listener(
        onPointerDown: _handleTouch,
        onPointerMove: _handleTouch,
        onPointerUp: (e) => _handleTouch(e, isUp: true),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ...activeTouches.values
                .map((touch) => AnimatedCircle(
                      position: touch.position,
                      color: Colors.red,
                      animationType: selectedAnimation,
                    ))
                ,
          ],
        ),
      ),
    );
  }
}

class TouchData {
  final Offset position;
  final Color color;

  TouchData({
    required this.position,
    required this.color,
  });
}
