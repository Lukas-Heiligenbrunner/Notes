import 'dart:ui';

class Stroke {
  List<Point> points = <Point>[];

  @override
  String toString() {
    return 'Stroke{points: $points}';
  }

  Stroke.fromPoints(this.points);
  Stroke();
}

class Point {
  final Offset point;
  final double thickness;

  Point(this.point, this.thickness);
}
