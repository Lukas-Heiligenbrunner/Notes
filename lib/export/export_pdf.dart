import 'dart:io';
import 'dart:ui';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../canvas/document_types.dart';
import '../savesystem/path.dart';

const _a4width = 210 * PdfPageFormat.mm;
const _a4height = 297 * PdfPageFormat.mm;

class _StrokePDFPaint extends pw.Widget {
  List<Stroke> strokes;

  @override
  void layout(pw.Context context, pw.BoxConstraints constraints,
      {bool parentUsesSize = false}) {
    box =
        PdfRect.fromPoints(PdfPoint.zero, const PdfPoint(_a4width, _a4height));
  }

  @override
  void paint(pw.Context context) {
    super.paint(context);

    for (final stroke in strokes) {
      context.canvas.setStrokeColor(PdfColor.fromInt(stroke.color.value));
      for (int i = 0; i < stroke.points.length - 1; i++) {
        Offset pt1 = stroke.points[i].point * PdfPageFormat.mm;
        pt1 = Offset(pt1.dx, _a4width - pt1.dy);
        Offset pt2 = stroke.points[i + 1].point * PdfPageFormat.mm;
        pt2 = Offset(pt2.dx, _a4width - pt2.dy);

        context.canvas.setLineWidth(stroke.points[i].thickness);
        context.canvas.drawLine(pt1.dx, pt1.dy, pt2.dx, pt2.dy);
        context.canvas.strokePath();
      }
    }
  }

  _StrokePDFPaint(this.strokes);
}

void exportPDF(List<Stroke> strokes, String name) async {
  final pdf = pw.Document();

  const PdfPageFormat a4 = PdfPageFormat(_a4width, _a4height);

  pdf.addPage(pw.MultiPage(
    pageFormat: a4,
    build: (context) => [_StrokePDFPaint(strokes)],
  ));

  final path = await getSavePath();
  final file = File('${path.path}${Platform.pathSeparator}$name');
  await file.writeAsBytes(await pdf.save(), flush: true);
}
