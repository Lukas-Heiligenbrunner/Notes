import 'package:flutter/material.dart';

class IconMaterialButton extends StatelessWidget {
  const IconMaterialButton(
      {Key? key,
      required this.icon,
      required this.color,
      required this.onPressed,
      this.selected,
      this.iconSize,
      this.rotation})
      : super(key: key);

  final Widget icon;
  final Color color;
  final void Function() onPressed;
  final bool? selected;
  final double? iconSize;
  final double? rotation;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ?? false ? const Color(0xff6e6e6e) : Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: IconButton(
        icon: _buildIcon(),
        iconSize: iconSize ?? 28,
        color: color,
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildIcon() {
    return rotation == null
        ? icon
        : Transform.rotate(
            angle: rotation!,
            child: icon,
          );
  }
}
