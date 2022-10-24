import 'package:flutter/material.dart';

import 'document_types.dart';

class MyPainter extends CustomPainter {
  List<Stroke> strokes = <Stroke>[];

  MyPainter({required this.strokes});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.square;
      // ..strokeWidth = 3.0;

    canvas.drawColor(Color.fromRGBO(255, 255, 255, .1), BlendMode.src);

    for(final stroke in strokes){
      for(int i = 0; i < stroke.points.length -1; i++){
        final pt1 = stroke.points[i].point;
        final pt2 = stroke.points[i+1].point;

        // final strokewidth = _calcAngleDependentWidth(pt1, pt2, stroke.points[i].thickness);
        canvas.drawLine(pt1, pt2, paint..strokeWidth = stroke.points[i].thickness);
      }
    }
  }

  @override
  bool shouldRepaint(MyPainter oldDelegate) {
    return oldDelegate.strokes != strokes;
  }
}
