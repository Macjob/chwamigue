import 'package:flutter/material.dart';
import 'dart:async';
import '../models/animation_option.dart';
import '../widgets/animated_circle.dart';
import '../utils/touch_manager.dart';

class AnimationSelector extends StatefulWidget {
  const AnimationSelector({super.key});
  @override
  State<AnimationSelector> createState() => _AnimationSelectorState();
}

class _AnimationSelectorState extends State<AnimationSelector> {
  AnimationOption selectedAnimation = AnimationOption.scale;
  Map<int, TouchCircle> activeTouches = {};
  bool showFixedCircle = false;
  Timer? _selectionTimer;

  // Nuevas variables para lógica de ganador
  TouchCircle? _winner;
  bool _showWinner = false;
  Color _backgroundColor = Colors.white;

  void _handleTouch(PointerEvent event, {bool isUp = false}) {
    if (_showWinner && event is PointerDownEvent) {
      setState(() {
        _showWinner = false;
        _backgroundColor = Colors.white;
        activeTouches.clear();
        _winner = null;
      });
    }

    if (event is PointerDownEvent || event is PointerMoveEvent) {
      setState(() {
        activeTouches[event.pointer] = TouchCircle(
          pointerId: event.pointer,
          position: event.localPosition,
          color: Colors.primaries[event.pointer % Colors.primaries.length],
        );
      });

      if (event is PointerDownEvent) {
        _selectionTimer?.cancel();
        _selectionTimer = Timer(const Duration(seconds: 5), () {
          if (mounted && activeTouches.isNotEmpty) {
            _selectRandomFinger();
          }
        });
      }
    } else if (isUp) {
      setState(() {
        activeTouches.remove(event.pointer);
      });

      if (activeTouches.isEmpty) {
        _selectionTimer?.cancel();
        _selectionTimer = null;
      }
    }
  }

  void _selectRandomFinger() {
    if (activeTouches.isEmpty) return;
    final list = activeTouches.values.toList();
    final winner = (list..shuffle()).first;

    setState(() {
      _winner = TouchCircle(
        pointerId: winner.pointerId,
        position: winner.position,
        color: winner.color,
      );
      activeTouches = {winner.pointerId: _winner!};
      _backgroundColor = Colors.lightGreen.shade200;
      _showWinner = true;
      _selectionTimer = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selector de animación')),
      body: Stack(
        children: [
          Listener(
            onPointerDown: _handleTouch,
            onPointerMove: _handleTouch,
            onPointerUp: (e) => _handleTouch(e, isUp: true),
            child: Container(
              color: _backgroundColor,
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  if (showFixedCircle)
                    AnimatedCircle(
                      position: Offset(
                        MediaQuery.of(context).size.width / 2,
                        MediaQuery.of(context).size.height / 2,
                      ),
                      color: Colors.grey.withOpacity(0.3),
                      animationType: selectedAnimation,
                    ),
                  ...activeTouches.values.map(
                    (touch) => AnimatedCircle(
                      key: touch.key,
                      position: touch.position,
                      color: touch.color,
                      animationType: selectedAnimation,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Menú desplegable arriba a la izquierda
          Positioned(
            top: 16,
            left: 16,
            child: DropdownButton<String>(
              value: showFixedCircle ? 'fixed' : selectedAnimation.name,
              onChanged: (value) {
                setState(() {
                  if (value == 'fixed') {
                    showFixedCircle = true;
                  } else {
                    showFixedCircle = false;
                    selectedAnimation = AnimationOption.values
                        .firstWhere((e) => e.name == value);
                  }
                });
              },
              items: [
                ...AnimationOption.values
                    .map((e) => DropdownMenuItem(
                          value: e.name,
                          child: Text(e.displayName),
                        )),
                const DropdownMenuItem(
                  value: 'fixed',
                  child: Text('Mostrar círculo fijo'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
