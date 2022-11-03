import 'package:flutter/material.dart';

import '../canvas/document_types.dart';
import 'note_file.dart';

extension LineLoading on NoteFile {
  Future<List<Stroke>> loadStrokes() async {
    const sql = '''
SELECT x, y, thickness, strokeid, points.id, s.color
from points
         JOIN strokes s on s.id = strokeid
ORDER BY strokeid
''';
    final query = await db().rawQuery(sql);
    int strokeid = -1;
    List<Stroke> strokes = [];

    for (final i in query) {
      final int csid = i['strokeid'] as int;
      if (csid != strokeid) {
        strokeid = csid;
        strokes.add(Stroke(strokeid, Color(i['color'] as int)));
      }
      final Point p = Point(
          Offset(i['x'] as double, i['y'] as double), i['thickness'] as double);
      strokes.last.points.add(p);
    }

    return strokes;
  }

  // create new stroke in file and return strokeid
  Future<void> addStroke(int newStrokeId, Color color) async {
    await db().insert(
        'strokes', {'color': color.value, 'elevation': 0, 'id': newStrokeId});
  }

  // add one point to a stroke in db
  Future<void> addPoint(int strokeid, Point p) async {
    await db().insert('points', {
      'x': p.point.dx,
      'y': p.point.dy,
      'thickness': p.thickness,
      'strokeid': strokeid
    });
  }

  // add list of points to a stroke in db
  Future<void> addPoints(int strokeid, List<Point> pts) async {
    final batch = db().batch();
    for (final p in pts) {
      batch.insert('points', {
        'x': p.point.dx,
        'y': p.point.dy,
        'thickness': p.thickness,
        'strokeid': strokeid
      });
    }
    await batch.commit();
  }

  Future<void> removeStroke(int id) async {
    final batch = db().batch();
    batch.delete('strokes', where: 'id = $id');
    batch.delete('points', where: 'strokeid = $id');
    await batch.commit();
  }
}
