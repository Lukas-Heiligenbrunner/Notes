import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:notes/canvas/my_painter.dart';
import 'package:notes/canvas/screen_document_mapping.dart';

import 'document_types.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({Key? key}) : super(key: key);

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  List<Stroke> _strokes = [];
  bool allowDrawWithFinger = false;

  double zoom = .75;
  double basezoom = 1.0;
  Offset offset = const Offset(.0, .0);

  // todo better pen system
  bool eraseractive = false;

  @override
  void initState() {
    super.initState();

    // todo might be weird behaviour if used with short side
    final screenWidth =
        (window.physicalSize.longestSide / window.devicePixelRatio);
    _calcNewPageOffset(const Offset(.0, .0), screenWidth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.blueGrey, actions: [
        // todo temp icon only
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            setState(() {
              eraseractive = !eraseractive;
            });
          },
        )
      ]),
      body: _buildCanvas(),
    );
  }

  double _calcTiltedWidth(double baseWidth, double tilt) {
    if (tilt == .0) return baseWidth;
    return baseWidth * tilt;
  }

  double _calcAngleDependentWidth(Point pt1, Point pt2, double basetickness) {
    double dx = pt2.point.dx - pt1.point.dx;
    double dy = pt2.point.dy - pt1.point.dy;

    // todo those deltas to small to get an accurate direction!

    double alpha = atan(dx / dy);
    // alpha has range from 0 - 2pi
    // we want 0.5 -1;

    alpha /= (2 * pi * 2);
    alpha += .5;

    double thickness = basetickness * alpha;
    return thickness;
  }

  // calculate new page offset from mousepointer delta
  void _calcNewPageOffset(Offset delta, double canvasWidth) {
    if (zoom > 1.0) {
      Offset newOffset = offset + delta;
      // don't allow navigating out of page if zoomed in
      if (newOffset.dx > .0) {
        setState(() {
          offset = Offset(.0, newOffset.dy);
        });
      } else if (newOffset.dx < (-canvasWidth * zoom) + canvasWidth) {
        setState(() {
          offset = Offset((-canvasWidth * zoom) + canvasWidth, newOffset.dy);
        });
        print(offset);
      } else {
        setState(() {
          offset = offset + delta;
        });
      }
    } else {
      setState(() {
        // keep page x centered if zoomed out
        offset = Offset(
            (canvasWidth - (canvasWidth * zoom)) / 2, offset.dy + delta.dy);
      });
    }
  }

  void _onPointerMove(PointerMoveEvent event, Size size) {
    Offset pos = event.localPosition;
    final scale = calcPageDependentScale(zoom, a4Page, size);
    pos = translateScreenToDocumentPoint(pos, scale, offset);

    if (!a4Page.contains(pos)) {
      return;
    }

    if (allowDrawWithFinger || event.kind != PointerDeviceKind.touch) {
      final pts = _strokes.last.points;

      if (pts.last.point == pos) return;

      double newWidth = _calcTiltedWidth(5.0, event.tilt);
      if (_strokes.last.points.length > 1) {
        newWidth =
            _calcAngleDependentWidth(pts.last, pts[pts.length - 2], newWidth);
      }

      setState(() {
        _strokes = List.from(_strokes, growable: false)
          ..last.addPoint(Point(pos, newWidth));
      });
    } else {
      _calcNewPageOffset(event.delta, size.width);
    }
  }

  Widget _buildCanvas() {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerMove: (e) => _onPointerMove(e, size),
        onPointerSignal: (event) {
          print('Button: ${event.buttons}');
        },
        onPointerDown: (event) {
          print('Button: ${event.buttons}');

          if (allowDrawWithFinger || event.kind != PointerDeviceKind.touch) {
            Offset pos = event.localPosition;
            final scale = calcPageDependentScale(zoom, a4Page, size);
            pos = translateScreenToDocumentPoint(pos, scale, offset);

            // todo line drawn on edge where line left page
            if (!a4Page.contains(pos)) return;

            if (eraseractive) return;

            setState(() {
              _strokes = List.from(_strokes)
                ..add(Stroke.fromPoints(
                    [Point(pos, _calcTiltedWidth(3.0, event.tilt))]));
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
            if (details.scale == 1.0) return;

            setState(() {
              zoom = (basezoom * details.scale).clamp(0.25, 5.0);
            });
          },
          onScaleEnd: (details) {
            basezoom = zoom;
          },
          onSecondaryTap: () {
            print('secctab');
          },
          onTertiaryTapDown: (details) {
            print('tertiary button');
          },
          child: CustomPaint(
            painter: MyPainter(strokes: _strokes, offset: offset, zoom: zoom),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}
