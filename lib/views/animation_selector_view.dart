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
  bool showFixedCircle = false; // NUEVA VARIABLE

  void _handleTouch(PointerEvent event, {bool isUp = false}) {
    print('TOUCH: ${event.position}');
    if (event is PointerDownEvent || event is PointerMoveEvent) {
      setState(() {
        activeTouches[event.pointer] = TouchCircle(
          pointerId: event.pointer,
          position: event.localPosition,
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
      body: Stack(
        children: [
          // Listener ocupa toda la pantalla
          Listener(
            onPointerDown: _handleTouch,
            onPointerMove: _handleTouch,
            onPointerUp: (e) => _handleTouch(e, isUp: true),
            child: Container(
              color: Colors.transparent, // Asegura que reciba eventos
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  if (showFixedCircle)
                    AnimatedCircle(
                      position: const Offset(200, 400),
                      color: Colors.red,
                      animationType: selectedAnimation,
                    ),
                  ...activeTouches.values
                      .map((touch) => AnimatedCircle(
                            position: touch.position,
                            color: touch.color,
                            animationType: selectedAnimation,
                          ))
                      .toList(),
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
                    selectedAnimation = AnimationOption.values.firstWhere((e) => e.name == value);
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
                  child: Text('Mostrar círculo fijon'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
