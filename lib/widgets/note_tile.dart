import 'dart:math';

import 'package:flutter/material.dart';

import '../canvas/document_types.dart';
import '../canvas/drawing_page.dart';
import '../helpers/vibrate.dart';

class NoteTile extends StatelessWidget {
  const NoteTile(
      {Key? key,
      required this.data,
      required this.selectionMode,
      required this.selected,
      required this.onSelectionChange})
      : super(key: key);

  final NoteMetaData data;
  final bool selectionMode;
  final bool selected;
  final void Function(bool) onSelectionChange;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (selectionMode) {
          onSelectionChange(!selected);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DrawingPage(meta: data),
            ),
          );
        }
      },
      onLongPress: () async {
        shortVibrate();
        onSelectionChange(!selected);
      },
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: AspectRatio(
                      aspectRatio: 1 / sqrt2,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (selectionMode)
                    Padding(
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      child: CustomPaint(
                        size: const Size(25, 25),
                        painter: _CirclePainter(selected),
                      ),
                    )
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              data.name,
              style: const TextStyle(color: Colors.white),
              overflow: TextOverflow.ellipsis,
            ),
            Text('${data.lastModified.hour}:${data.lastModified.minute}',
                style: const TextStyle(color: Colors.white))
          ],
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final bool selected;

  final _paint = Paint()..strokeWidth = .7;

  _CirclePainter(this.selected) {
    if (selected) {
      _paint.color = Colors.orange;
      _paint.style = PaintingStyle.fill;
    } else {
      _paint.color = Colors.black;
      _paint.style = PaintingStyle.stroke;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawOval(
      Rect.fromLTWH(0, 0, size.width, size.height),
      _paint,
    );
  }

  @override
  bool shouldRepaint(_CirclePainter oldDelegate) =>
      oldDelegate.selected != selected;
}
