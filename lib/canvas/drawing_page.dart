import 'dart:math';
import 'dart:ui';

import 'package:equations/equations.dart';
import 'package:flutter/material.dart';
import 'package:notes/canvas/my_painter.dart';

import 'document_types.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<Stroke> _strokes = [];
  bool allowDrawWithFinger = false;

  double zoom = .5;
  Offset scrollPos = const Offset(.0, .0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueGrey),
      body: _buildCanvas(),
    );
  }

  double _calcTiltedWidth(double baseWidth, double tilt) {
    return baseWidth * tilt;
  }

  double _calcAngleDependentWidth(List<Point> pts, double basetickness) {
    return basetickness;

    // todo do correct linear interpolation and extimate angle
    final lininterpol = PolynomialInterpolation(
        nodes: pts
            .map((e) => InterpolationNode(x: e.point.dx, y: e.point.dy))
            .toList(growable: false));
    lininterpol.compute(1.0);
    print(lininterpol.buildPolynomial().toString());

    // double angle = atan((pt2.dy - pt1.dy)/(pt2.dx - pt1.dx));

    final angle = 5 / (2 * pi);
    // print("pt1: ${pt1}, pt2: ${pt2}, angle: ${angle}");

    return basetickness * (angle / .5 + .5);
  }

  Widget _buildCanvas() {
    final width = MediaQuery.of(context).size.width;

    final zoomedwidth = width * zoom;

    return Scaffold(
      body: Listener(
        onPointerMove: (event) {
          // print(event.tilt);
          final pos = event.localPosition;
          final pts = _strokes.last.points;

          if(pts.last.point == pos) return;

          if (allowDrawWithFinger || event.kind != PointerDeviceKind.touch) {
            double newWidth = _calcTiltedWidth(3.0, event.tilt);

            if(_strokes.last.points.length > 1){
              // todo current point not in list
              newWidth = _calcAngleDependentWidth(pts.getRange(pts.length - 10 >= 0 ? pts.length -10 : 0, pts.length).toList(growable: false), event.tilt);
            }
            setState(() {
              _strokes = List.from(_strokes, growable: false)
                ..last.points.add(Point(pos, newWidth));
            });
          }
        },
        onPointerDown: (event) {
          if (allowDrawWithFinger || event.kind != PointerDeviceKind.touch) {
            setState(() {
              _strokes = List.from(_strokes)
                ..add(Stroke.fromPoints([Point(event.localPosition, _calcTiltedWidth(3.0, event.tilt))]));
            });
          }
        },

        onPointerUp: (event) {
          if (allowDrawWithFinger || event.kind != PointerDeviceKind.touch) {
            if (_strokes.last.points.length <= 1) {
              // if the line consists only of one point (point) add endpoint as the same to allow drawing a line
              // todo maybe solve this in custompainter in future
              setState(() {
                _strokes = List.from(_strokes, growable: false)
                  ..last.points.add(_strokes.last.points.last);
              });
            } else {
              setState(() {});
            }

            print(_strokes.length);
            print(_strokes.last.points.length);
          }
        },
        child: GestureDetector(
        onScaleUpdate: (details) {
          setState(() {
            zoom = details.scale;
          });
        },
        child: CustomPaint(
          painter: MyPainter(strokes: _strokes,offset: scrollPos, zoom: zoom),
          // todo not working
          size: Size.infinite, // todo add different paper dimensions
          ),
        ),
      ),
    );
  }
}
