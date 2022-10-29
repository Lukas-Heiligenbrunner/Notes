import 'dart:ui';

class Stroke {
  List<Point> points = <Point>[];

  double _minx = double.infinity;
  double _maxx = double.negativeInfinity;
  double _miny = double.infinity;
  double _maxy = double.negativeInfinity;

  final int id;

  @override
  String toString() {
    return 'Stroke{points: $points}';
  }

  void addPoint(Point point) {
    points.add(point);

    // update bounding rect
    _updateBoundingRect(point);
  }

  void _updateBoundingRect(Point p) {
    if (p.point.dx < _minx) _minx = p.point.dx;
    if (p.point.dx > _maxx) _maxx = p.point.dx;
    if (p.point.dy < _miny) _miny = p.point.dy;
    if (p.point.dy > _maxy) _maxy = p.point.dy;
  }

  Rect getBoundingRect() {
    return Rect.fromPoints(Offset(_minx, _miny), Offset(_maxx, _maxy));
  }

  Stroke.fromPoints(this.points, this.id);
  Stroke(this.id);
}

class Point {
  final Offset point;
  final double thickness;

  Point(this.point, this.thickness);
}
