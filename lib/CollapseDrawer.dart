import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes/drawer_item.dart';

enum View {
  all, shared, recycle, folders
}

class CollapseDrawer extends StatefulWidget {
  const CollapseDrawer({Key? key, required this.onPageChange, required this.activePage}) : super(key: key);
  final void Function(View newPage) onPageChange;
  final View activePage;

  @override
  State<CollapseDrawer> createState() => _CollapseDrawerState();
}

class _CollapseDrawerState extends State<CollapseDrawer>
    with SingleTickerProviderStateMixin {
  bool collapsed = true;

  late Animation collapseAnimation;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    collapseAnimation = Tween<double>(begin: 62, end: 300).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
      child: Container(
        color: const Color.fromRGBO(0, 0, 0, .75),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(width: collapseAnimation.value),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  IconButton(
                      onPressed: () {
                        collapsed ? controller.forward() : controller.reverse();
                        setState(() => collapsed = !collapsed);
                      },
                      icon: const Icon(
                        Icons.menu,
                        size: 28,
                        color: Color.fromRGBO(255, 255, 255, .75),
                      )),
                  if (!collapsed) ...[
                    const Expanded(child: SizedBox()),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.settings_outlined,
                          size: 26,
                          color: Color.fromRGBO(255, 255, 255, .55),
                        )),
                    const SizedBox(
                      width: 15,
                    )
                  ]
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              Expanded(
                  child: ListView(
                children: [
                  DrawerItem(
                      dta: ItemData("All Notes", Icons.book),
                      collapsed: collapsed,
                      active: widget.activePage == View.all,
                      onTap: () => widget.onPageChange(View.all)),
                  DrawerItem(
                      dta: ItemData("Shared Notebooks", Icons.person_outline),
                      collapsed: collapsed,
                      active: widget.activePage == View.shared,
                      onTap: () => widget.onPageChange(View.shared)),
                  DrawerItem(
                      dta: ItemData("Recycle bin", CupertinoIcons.trash),
                      collapsed: collapsed,
                      active: widget.activePage == View.recycle,
                      onTap: () => widget.onPageChange(View.recycle)),
                  DrawerItem(
                      dta: ItemData("Folders", Icons.folder_outlined),
                      collapsed: collapsed,
                      active: widget.activePage == View.folders,
                      onTap: () => widget.onPageChange(View.folders)),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
