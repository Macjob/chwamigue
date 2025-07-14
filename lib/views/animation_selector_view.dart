import 'package:flutter/material.dart';
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

  void _handleTouch(PointerEvent event, {bool isUp = false}) {
    if (event is PointerDownEvent || event is PointerMoveEvent) {
      setState(() {
        activeTouches[event.pointer] = TouchCircle(
          pointerId: event.pointer,
          position: event.position,
          color: Colors.primaries[event.pointer % Colors.primaries.length],
        );
      });
    } else if (isUp) {
      setState(() {
        activeTouches.remove(event.pointer);
      });

      if (activeTouches.isEmpty) {
        // Al soltar todos los dedos: seleccionar uno o más
        _selectRandomFinger(); 
      }
    }
  }

  void _selectRandomFinger() {
    if (activeTouches.isEmpty) return;
    final list = activeTouches.values.toList();
    final winner = (list..shuffle()).first;
    // podrías usar una lista para múltiples ganadores

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("¡Seleccionado!"),
        content: Text("Ganador: ${winner.pointerId}"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Selector de animación')),
      body: Column(
        children: [
          DropdownButton<AnimationOption>(
            value: selectedAnimation,
            onChanged: (value) => setState(() => selectedAnimation = value!),
            items: AnimationOption.values
                .map((e) => DropdownMenuItem(value: e, child: Text(e.displayName)))
                .toList(),
          ),
          Expanded(
            child: Listener(
              onPointerDown: _handleTouch,
              onPointerMove: _handleTouch,
              onPointerUp: (e) => _handleTouch(e, isUp: true),
              child: Stack(
                children: activeTouches.values
                    .map((touch) => AnimatedCircle(
                          position: touch.position,
                          color: touch.color,
                          animationType: selectedAnimation,
                        ))
                    .toList(),
              ),
            ),
          )
        ],
      ),
    );
  }
}
