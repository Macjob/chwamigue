import 'package:flutter/material.dart';
import '../models/animation_option.dart';

class TouchCircle {
  final int pointerId;
  final Offset position;
  final Color color;

  TouchCircle({required this.pointerId, required this.position, required this.color});
}
