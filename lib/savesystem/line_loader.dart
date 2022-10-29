import 'dart:ui';

import 'note_file.dart';
import '../canvas/document_types.dart';

extension LineLoading on NoteFile {
  Future<List<Stroke>> loadStrokes() async {
    final query = await db().query('points',
        orderBy: 'strokeid',
        columns: ['x', 'y', 'thickness', 'strokeid', 'id']);
    int strokeid = -1;
    List<Stroke> strokes = [];

    for (final i in query) {
      final int csid = i['strokeid'] as int;
      if (csid != strokeid) {
        strokeid = csid;
        strokes.add(Stroke(strokeid));
      }
      final Point p = Point(
          Offset(i['x'] as double, i['y'] as double), i['thickness'] as double);
      strokes.last.points.add(p);
    }

    return strokes;
  }

  // create new stroke in file and return strokeid
  Future<void> addStroke(int newStrokeId) async {
    await db().insert(
        'strokes', {'color': 0xffffff, 'elevation': 0, 'id': newStrokeId});
  }

  Future<void> addPoint(int strokeid, Point p) async {
    await db().insert('points', {
      'x': p.point.dx,
      'y': p.point.dy,
      'thickness': p.thickness,
      'strokeid': strokeid
    });
  }

  Future<void> removeStroke(int id) async {
    await db().delete('strokes', where: 'id = $id');
    await db().delete('points', where: 'strokeid = $id');
  }
}
