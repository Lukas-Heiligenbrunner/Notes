import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';

import 'document_types.dart';
import 'my_painter.dart';

enum Pen { eraser, pen, highlighter, selector }

class PaintController extends ChangeNotifier {
  Pen activePen = Pen.pen;
  List<Stroke> strokes = [];
  final bool _allowDrawWithFinger = false;

  void changePen(Pen pen) {
    activePen = pen;
    notifyListeners();
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

  void pointDownEvent(Offset offset, PointerDeviceKind pointer, double tilt) {
    if (_allowDrawWithFinger || pointer != PointerDeviceKind.touch) {
      // todo line drawn on edge where line left page
      if (!a4Page.contains(offset)) return;

      // todo handle other pens
      if (activePen != Pen.pen) return;

      strokes
          .add(Stroke.fromPoints([Point(offset, _calcTiltedWidth(3.0, tilt))]));
      notifyListeners();
    }
  }

  void pointUpEvent(PointerDeviceKind pointer) {
    if (activePen == Pen.eraser) return;

    if (_allowDrawWithFinger || pointer != PointerDeviceKind.touch) {
      if (strokes.last.points.length <= 1) {
        // if the line consists only of one point (point) add endpoint as the same to allow drawing a line
        // todo maybe solve this in custompainter in future
        strokes.last.points.add(strokes.last.points.last);
        notifyListeners();
      }
    }
  }

  void pointMoveEvent(Offset offset, PointerDeviceKind pointer, double tilt) {
    if (!a4Page.contains(offset)) {
      return;
    }

    if (_allowDrawWithFinger || pointer != PointerDeviceKind.touch) {
      switch (activePen) {
        case Pen.eraser:
          // todo dynamic eraser size
          final eraserrect = Rect.fromCircle(center: offset, radius: 3);
          for (final stroke in strokes) {
            // check if delete action was within bounding rect of stroke
            if (stroke.getBoundingRect().contains(offset)) {
              // check if eraser hit an point within its range
              for (final pt in stroke.points) {
                if (eraserrect.contains(pt.point)) {
                  strokes.remove(stroke);
                  notifyListeners();
                  return;
                }
              }
            }
          }
          break;
        case Pen.pen:
          final pts = strokes.last.points;
          if (pts.last.point == offset) return;

          double newWidth = _calcTiltedWidth(5.0, tilt);
          if (strokes.last.points.length > 1) {
            newWidth = _calcAngleDependentWidth(
                pts.last, pts[pts.length - 2], newWidth);
          }

          strokes.last.addPoint(Point(offset, newWidth));
          break;
        case Pen.highlighter:
          // TODO: Handle this case.
          break;
        case Pen.selector:
          // TODO: Handle this case.
          break;
      }
      notifyListeners();
    }
  }
}
