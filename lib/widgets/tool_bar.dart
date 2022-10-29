import 'package:adwaita_icons/adwaita_icons.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/emojione_monotone.dart';
import 'package:iconify_flutter/icons/jam.dart';

import '../canvas/paint_controller.dart';
import 'icon_material_button.dart';

class ToolBar extends StatefulWidget {
  const ToolBar({Key? key, required this.onPenChange}) : super(key: key);

  final void Function(Pen pen) onPenChange;

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  Pen activepen = Pen.pen;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff3f3f3f),
      width: 45,
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          IconMaterialButton(
            icon: const Iconify(
              EmojioneMonotone.fountain_pen,
              color: Color.fromRGBO(255, 255, 255, .85),
            ),
            color: const Color.fromRGBO(255, 255, 255, .85),
            onPressed: () {
              setState(() => activepen = Pen.pen);
              widget.onPenChange(Pen.pen);
            },
            selected: activepen == Pen.pen,
            iconSize: 24,
          ),
          IconMaterialButton(
            icon: const Iconify(
              Jam.highlighter,
              color: Color.fromRGBO(255, 255, 255, .85),
            ),
            color: const Color.fromRGBO(255, 255, 255, .85),
            onPressed: () {
              setState(() => activepen = Pen.highlighter);
              widget.onPenChange(Pen.highlighter);
            },
            selected: activepen == Pen.highlighter,
            iconSize: 24,
          ),
          IconMaterialButton(
            icon: Transform.translate(
              offset: const Offset(-2.0, .0),
              child: const AdwaitaIcon(AdwaitaIcons.eraser2),
            ),
            color: const Color.fromRGBO(255, 255, 255, .85),
            onPressed: () {
              setState(() => activepen = Pen.eraser);
              widget.onPenChange(Pen.eraser);
            },
            iconSize: 24,
            selected: activepen == Pen.eraser,
          ),
          IconMaterialButton(
            icon: const Icon(FluentIcons.select_object_24_regular),
            color: const Color.fromRGBO(255, 255, 255, .85),
            onPressed: () {
              setState(() => activepen = Pen.selector);
              widget.onPenChange(Pen.selector);
            },
            selected: activepen == Pen.selector,
            iconSize: 24,
          ),
        ],
      ),
    );
  }
}
