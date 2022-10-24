import 'package:flutter/material.dart';

import 'document_types.dart';

class MyPainter extends CustomPainter {
  List<Stroke> strokes;
  double zoom;
  Offset offset;

  MyPainter({required this.strokes, required this.zoom, required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.blue
      ..strokeCap = StrokeCap.square;



      // ..strokeWidth = 3.0;
    // canvas.scale(zoom);
    print("zoom: ${zoom}");
    canvas.drawColor(Color.fromRGBO(255, 255, 255, .1), BlendMode.src);

    final pagewidth = size.width * zoom;

    final sidewidth = (size.width - pagewidth) / 2;
    canvas.drawLine(Offset(sidewidth, .0), Offset(sidewidth, size.height), paint);
    canvas.drawLine(Offset(sidewidth + pagewidth, .0), Offset(sidewidth + pagewidth, size.height), paint);

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
