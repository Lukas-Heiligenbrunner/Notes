import 'package:flutter/material.dart';

import '../canvas/document_types.dart';
import 'note_file.dart';

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
        strokes.add(Stroke(strokeid, Colors.green));
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
