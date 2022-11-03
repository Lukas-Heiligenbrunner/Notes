import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../savesystem/note_file.dart';
import '../widgets/drawing_page_top_actions.dart';
import '../widgets/tool_bar.dart';
import 'document_types.dart';
import 'my_painter.dart';
import 'paint_controller.dart';
import 'screen_document_mapping.dart';

/// Handles input events and draws canvas element
class DrawingPage extends StatefulWidget {
  // path to the .dbnote file
  final NoteMetaData meta;

  const DrawingPage({Key? key, required this.meta}) : super(key: key);

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  double zoom = .75;
  double basezoom = 1.0;
  Offset offset = const Offset(.0, .0);

  late PaintController controller;
  late NoteFile noteFile = NoteFile(widget.meta.filePath);

  @override
  void initState() {
    super.initState();

    controller = PaintController(noteFile);
    debugPrint('initializing strokes from file');
    noteFile.init().then((value) => controller.loadStrokesFromFile());

    // todo might be weird behaviour if used with short side
    final screenWidth =
        (window.physicalSize.longestSide / window.devicePixelRatio);
    _calcNewPageOffset(const Offset(.0, .0), screenWidth - 45);
  }

  @override
  void dispose() {
    super.dispose();

    noteFile.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.meta.name), actions: [
        DrawingPageTopActions(controller: controller, noteMetaData: widget.meta)
      ]),
      body: Row(
        children: [
          ToolBar(
            onPenChange: (pen) {
              controller.changePen(pen);
            },
          ),
          Expanded(child: RepaintBoundary(child: _buildCanvas())),
        ],
      ),
    );
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
        debugPrint(offset.toString());
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

    controller.pointMoveEvent(pos, event);

    if (event.kind == PointerDeviceKind.touch ||
        (event.kind == PointerDeviceKind.mouse &&
            event.buttons == kSecondaryMouseButton)) {
      _calcNewPageOffset(event.delta, size.width);
    }
  }

  Widget _buildCanvas() {
    final size = MediaQuery.of(context).size;
    final canvasSize = Size(size.width - 45, size.height);

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerMove: (e) => _onPointerMove(e, canvasSize),
      onPointerDown: (d) {
        Offset pos = d.localPosition;
        final scale = calcPageDependentScale(zoom, a4Page, canvasSize);
        pos = translateScreenToDocumentPoint(pos, scale, offset);
        controller.pointDownEvent(pos, d);
      },
      onPointerUp: (e) {
        controller.pointUpEvent(e);
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
        child: CustomPaint(
          painter: MyPainter(
              offset: offset,
              zoom: zoom,
              canvasSize: canvasSize,
              controller: controller),
          size: canvasSize,
        ),
      ),
    );
  }
}
