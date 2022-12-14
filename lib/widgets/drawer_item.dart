import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  const DrawerItem(
      {Key? key,
      required this.dta,
      this.endText,
      required this.collapsed,
      required this.active,
      required this.onTap})
      : super(key: key);
  final ItemData dta;
  final String? endText;
  final bool collapsed;
  final bool active;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(left: 9, top: 2, bottom: 2, right: 9),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: active ? const Color(0xff4d4d4d) : Colors.transparent,
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 9, top: 13, bottom: 13, right: 9),
              child: Row(
                children: [
                  Icon(
                    dta.icon,
                    size: 23,
                    color: const Color(0xffe5e5e5),
                  ),
                  if (!collapsed) ...[
                    const SizedBox(
                      width: 17,
                    ),
                    Text(
                      dta.name,
                      style: const TextStyle(
                          color: Color(0xffe5e5e5), fontSize: 16),
                    ),
                    Expanded(child: Container()),
                    Text(
                      endText ?? '',
                      style: const TextStyle(color: Color(0xffafafaf)),
                    ),
                    const SizedBox(
                      width: 15,
                    )
                  ]
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemData {
  String name;
  IconData icon;

  ItemData(this.name, this.icon);

  @override
  String toString() {
    return 'ItemData{name: $name, icon: $icon}';
  }
}
