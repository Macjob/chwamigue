import 'package:flutter/material.dart';

enum AnimationOption {
  scale(displayName: 'Agrandar', begin: 1.0, end: 1.5, curve: null),
  bounce(displayName: 'Rebote', begin: 0.8, end: 1.2, curve: Curves.bounceIn),
  glow(displayName: 'Brillo', begin: 1.0, end: 1.0, curve: null), // efecto personalizado
  // Puedes agregar más aquí
  ;

  const AnimationOption({required this.displayName, required this.begin, required this.end, required this.curve});
  final String displayName;
  final double begin;
  final double end;
  final Curve? curve;
}
