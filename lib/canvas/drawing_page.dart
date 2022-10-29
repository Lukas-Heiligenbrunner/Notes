import 'dart:math';
import 'dart:ui';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:notes/savesystem/note_file.dart';
import 'my_painter.dart';
import 'paint_controller.dart';
import 'screen_document_mapping.dart';

import '../icon_material_button.dart';
import '../tool_bar.dart';

/// Handles input events and draws canvas element
class DrawingPage extends StatefulWidget {
  // path to the .dbnote file
  final String filePath;

  const DrawingPage({Key? key, required this.filePath}) : super(key: key);

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  double zoom = .75;
  double basezoom = 1.0;
  Offset offset = const Offset(.0, .0);

  late PaintController controller;
  late NoteFile noteFile = NoteFile(widget.filePath);

  @override
  void initState() {
    super.initState();

    controller = PaintController(noteFile);
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
      appBar: AppBar(backgroundColor: Colors.blueGrey, actions: [
        IconMaterialButton(
          icon: const Icon(FluentIcons.book_open_48_filled),
          color: const Color.fromRGBO(255, 255, 255, .85),
          onPressed: () {
            // todo implement
          },
        ),
        IconMaterialButton(
          icon: const Icon(FluentIcons.document_one_page_24_regular),
          color: const Color.fromRGBO(255, 255, 255, .85),
          onPressed: () {
            // todo implement
          },
        ),
        IconMaterialButton(
          icon: const Icon(Icons.attachment_outlined),
          color: const Color.fromRGBO(255, 255, 255, .85),
          onPressed: () {
            // todo implement
          },
          rotation: -pi / 4,
        ),
        IconMaterialButton(
          icon: const Icon(Icons.more_vert),
          color: const Color.fromRGBO(255, 255, 255, .85),
          onPressed: () {
            // todo implement
          },
        ),
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
        print(offset);
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

    controller.pointMoveEvent(pos, event.kind, event.tilt);

    if (event.kind == PointerDeviceKind.touch) {
      _calcNewPageOffset(event.delta, size.width);
    }
  }

  Widget _buildCanvas() {
    final size = MediaQuery.of(context).size;
    final canvasSize = Size(size.width - 45, size.height);

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerMove: (e) => _onPointerMove(e, canvasSize),
      onPointerDown: (event) {
        Offset pos = event.localPosition;
        final scale = calcPageDependentScale(zoom, a4Page, canvasSize);
        pos = translateScreenToDocumentPoint(pos, scale, offset);
        controller.pointDownEvent(pos, event.kind, event.tilt);
      },
      onPointerUp: (event) {
        controller.pointUpEvent(event.kind);
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
