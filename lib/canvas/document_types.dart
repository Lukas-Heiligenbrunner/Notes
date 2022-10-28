import 'dart:ui';

class Stroke {
  List<Point> points = <Point>[];

  double _minx = double.infinity;
  double _maxx = double.negativeInfinity;
  double _miny = double.infinity;
  double _maxy = double.negativeInfinity;

  @override
  String toString() {
    return 'Stroke{points: $points}';
  }

  void addPoint(Point point) {
    points.add(point);

    // update bounding rect
    if (point.point.dx < _minx) _minx = point.point.dx;
    if (point.point.dx > _maxx) _maxx = point.point.dx;
    if (point.point.dy < _miny) _miny = point.point.dy;
    if (point.point.dy > _maxy) _maxy = point.point.dy;
  }

  Rect getBoundingRect() {
    return Rect.fromPoints(Offset(_minx, _miny), Offset(_maxx, _maxy));
  }

  Stroke.fromPoints(this.points);
  Stroke();
}

class Point {
  final Offset point;
  final double thickness;

  Point(this.point, this.thickness);
}
