import 'dart:math';
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../savesystem/line_loader.dart';
import '../savesystem/note_file.dart';
import 'document_types.dart';
import 'my_painter.dart';

enum Pen { eraser, pen, highlighter, selector }

class PaintController extends ChangeNotifier {
  final bool _allowDrawWithFinger = false;
  final NoteFile file;

  Offset? _currentPointerPosition;
  Pen activePen = Pen.pen;
  List<Stroke> strokes = [];

  PaintController(this.file);

  void changePen(Pen pen) {
    activePen = pen;
    notifyListeners();
  }

  /// return current position of pointer
  /// null if nowhere hovering or painting
  Offset? getPointerPosition() {
    return _currentPointerPosition;
  }

  void pointDownEvent(Offset offset, PointerDownEvent e) async {
    if (_allowedToDraw(e.kind, e.buttons)) {
      // todo line drawn on edge where line left page
      if (!a4Page.contains(offset)) return;

      // todo handle other pens
      if (activePen == Pen.eraser || activePen == Pen.selector) return;

      int strokeid = strokes.isNotEmpty ? strokes.last.id + 1 : 0;
      final color = activePen == Pen.pen
          ? const Color(0xFF444444)
          : Colors.yellow.withOpacity(.3);
      strokes.add(Stroke.fromPoints(
          [Point(offset, _calcTiltedWidth(3.0, e.tilt))], strokeid, color));
      file.addStroke(strokeid, color);
      notifyListeners();
    }
  }

  void pointUpEvent(PointerUpEvent e) {
    _currentPointerPosition = null;
    notifyListeners();

    if (activePen == Pen.eraser) return;

    // pointerupevent doesn't deliver correct event button
    if (_allowedToDraw(e.kind, 1)) {
      final lastStroke = strokes.last;
      if (lastStroke.points.length <= 1) {
        // if the line consists only of one point (point) add endpoint as the same to allow drawing a line
        lastStroke.points.add(lastStroke.points.last);
        file.addPoint(lastStroke.id, lastStroke.points.last);
        notifyListeners();
      } else {
        debugPrint('adding points to db');
        file.addPoints(lastStroke.id, lastStroke.points);
      }
    }
  }

  void pointMoveEvent(Offset offset, PointerMoveEvent event) {
    _currentPointerPosition = offset;

    if (!a4Page.contains(offset)) {
      return;
    }

    if (_allowedToDraw(event.kind, event.buttons)) {
      switch (activePen) {
        case Pen.eraser:
          // todo dynamic eraser size
          final eraserrect = Rect.fromCircle(center: offset, radius: 2.0);
          for (final stroke in strokes) {
            // check if delete action was within bounding rect of stroke
            if (stroke.getBoundingRect().overlaps(eraserrect)) {
              // check if eraser hit an point within its range
              for (final pt in stroke.points) {
                if (eraserrect.contains(pt.point)) {
                  file.removeStroke(stroke.id);
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
          // avoid duplicates
          if (pts.last.point == offset) return;

          double newWidth = _calcTiltedWidth(4.0, event.tilt);
          if (pts.length > 1) {
            newWidth = _calcAngleDependentWidth(pts.last,
                pts[pts.length - (pts.length > 5 ? 5 : pts.length)], newWidth);
          }

          strokes.last.addPoint(Point(offset, newWidth));
          break;
        case Pen.highlighter:
          final pts = strokes.last.points;
          // avoid duplicates
          if (pts.last.point == offset) return;

          strokes.last.addPoint(Point(offset, 15.0));
          break;
        case Pen.selector:
          // TODO: Handle this case.
          break;
      }
      notifyListeners();
    }
  }

  Future<void> loadStrokesFromFile() async {
    strokes = await file.loadStrokes();
    debugPrint('finished loading strokes from file');
    notifyListeners();
  }

  /// check if pointer event is allowed to draw points
  bool _allowedToDraw(PointerDeviceKind kind, int button) {
    return (_allowDrawWithFinger && kind == PointerDeviceKind.touch) ||
        kind == PointerDeviceKind.stylus ||
        (kind == PointerDeviceKind.mouse && button == kPrimaryMouseButton);
  }

  double _calcAngleDependentWidth(Point pt1, Point pt2, double basetickness) {
    final delta = pt2.point - pt1.point;
    final normalizedDelta =
        delta / sqrt(delta.dx * delta.dx + delta.dy * delta.dy);

    double alpha = asin(normalizedDelta.dy);
    // range [-pi,pi]
    alpha += (3 * pi / 4);
    // range [0,inf]
    alpha = alpha % (2 * pi);
    // range [0,2pi]
    alpha -= pi;
    // range [-pi,pi]
    alpha = alpha.abs();
    // range [0,pi]
    alpha /= pi;
    // range [0,1]
    alpha += .5;
    // range [.5,1.5]

    return basetickness * alpha;
  }

  double _calcTiltedWidth(double baseWidth, double tilt) {
    if (tilt == .0) return baseWidth;
    return baseWidth * tilt;
  }
}
