import 'dart:math';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../canvas/paint_controller.dart';
import '../export/export_pdf.dart';
import 'icon_material_button.dart';

class DrawingPageTopActions extends StatefulWidget {
  const DrawingPageTopActions(
      {Key? key, required this.controller, required this.noteName})
      : super(key: key);
  final PaintController controller;
  final String noteName;

  @override
  State<DrawingPageTopActions> createState() => _DrawingPageTopActionsState();
}

class _DrawingPageTopActionsState extends State<DrawingPageTopActions> {
  FToast fToast = FToast();

  @override
  Widget build(BuildContext context) {
    return Row(children: [
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
          showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(
                  double.infinity, 0, 0, double.infinity),
              color: const Color(0xff252525),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              items: [
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text(
                    'Add to',
                    style: TextStyle(color: Color(0xffe5e5e5)),
                  ),
                ),
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text(
                    'Tags',
                    style: TextStyle(color: Color(0xffe5e5e5)),
                  ),
                ),
                PopupMenuItem<int>(
                  value: 0,
                  child: const Text(
                    'Save as file',
                    style: TextStyle(color: Color(0xffe5e5e5)),
                  ),
                  onTap: () async {
                    // todo move in correct submenu
                    await exportPDF(
                        widget.controller.strokes, '${widget.noteName}.pdf');

                    Widget toast = Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: const Color(0xff252525),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(
                            Icons.check,
                            color: Color(0xffe5e5e5),
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Text('Pdf saved!',
                              style: TextStyle(color: Color(0xffe5e5e5))),
                        ],
                      ),
                    );

                    fToast.showToast(
                      child: toast,
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: const Duration(seconds: 2),
                    );
                  },
                ),
                const PopupMenuItem<int>(
                  value: 0,
                  child: Text(
                    'Print',
                    style: TextStyle(color: Color(0xffe5e5e5)),
                  ),
                ),
              ]);
        },
      ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }
}