import 'package:flutter/material.dart';

Offset translateScreenToDocumentPoint(Offset pt, double scale, Offset offset) {
  return pt.translate(-offset.dx, -offset.dy).scale(1 / scale, 1 / scale);
}

Offset translateDocumentToScreenPoint(Offset pt, double scale, Offset offset) {
  return pt.scale(scale, scale).translate(offset.dx, offset.dy);
}

double calcPageDependentScale(double scale, Rect page, Size canvasSize) {
  return scale * (canvasSize.width / page.width);
}
