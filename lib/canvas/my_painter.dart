import 'dart:math';

import 'package:flutter/material.dart';

import 'paint_controller.dart';
import 'screen_document_mapping.dart';

final Rect a4Page =
    Rect.fromPoints(const Offset(.0, .0), const Offset(210, 210 * sqrt2));

class MyPainter extends CustomPainter {
  double zoom;
  Offset offset;
  Size canvasSize;
  PaintController controller;

  late Pen activePen;

  MyPainter(
      {required this.zoom,
      required this.offset,
      required this.canvasSize,
      required this.controller})
      : super(repaint: controller) {
    activePen = controller.activePen;

    controller.addListener(() {
      activePen = controller.activePen;
    });
  }

  Offset _translatept(Offset pt, Size canvasSize) {
    final scale = calcPageDependentScale(zoom, a4Page, canvasSize);
    return translateDocumentToScreenPoint(pt, scale, offset);
  }

  Paint backgroundPaint = Paint()..color = Colors.white;

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.square;

    // clipping canvas to reqired size
    canvas.clipRect(Offset.zero & size);

    canvas.drawColor(const Color(0xff6e6e6e), BlendMode.src);
    canvas.drawRect(
        Rect.fromPoints(_translatept(const Offset(0, .0), size),
            _translatept(a4Page.bottomRight, size)),
        backgroundPaint);

    for (final stroke in controller.strokes) {
      paint.color = stroke.color;
      for (int i = 0; i < stroke.points.length - 1; i++) {
        Offset pt1 = stroke.points[i].point;
        pt1 = _translatept(pt1, size);
        Offset pt2 = stroke.points[i + 1].point;
        pt2 = _translatept(pt2, size);

        // final strokewidth = _calcAngleDependentWidth(pt1, pt2, stroke.points[i].thickness);
        canvas.drawLine(
            pt1, pt2, paint..strokeWidth = stroke.points[i].thickness);
      }
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return oldDelegate.zoom != zoom || oldDelegate.offset != offset;
  }
}
