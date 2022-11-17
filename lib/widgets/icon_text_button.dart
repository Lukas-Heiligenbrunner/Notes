import 'package:flutter/material.dart';

import 'icon_material_button.dart';

class IconTextButton extends StatelessWidget {
  const IconTextButton(
      {Key? key,
      required this.icon,
      required this.color,
      required this.onPressed,
      required this.text,
      this.iconSize})
      : super(key: key);
  final Widget icon;
  final Color color;
  final void Function() onPressed;
  final String text;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconMaterialButton(
            icon: icon, color: color, onPressed: onPressed, iconSize: iconSize),
        Text(
          text,
          style: TextStyle(color: color),
        )
      ],
    );
  }
}
