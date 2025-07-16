import 'package:flutter/material.dart';

class TouchCircle {
  final int pointerId;
  final Offset position;
  final Color color;
  final Key key;

  TouchCircle({
    required this.pointerId,
    required this.position,
    required this.color,
    Key? key,
  }) : key = key ?? UniqueKey();
}
