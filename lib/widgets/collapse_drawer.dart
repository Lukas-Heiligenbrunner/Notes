import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../context/file_change_notifier.dart';
import '../pages/settings_page.dart';
import 'drawer_item.dart';

enum View { all, shared, recycle, folders }

class CollapseDrawer extends StatefulWidget {
  const CollapseDrawer(
      {Key? key, required this.onPageChange, required this.activePage})
      : super(key: key);
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
    collapseAnimation = Tween<double>(begin: 62, end: 300)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top + 15),
      color: const Color(0xff000000),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
        child: Container(
          color: const Color(0xff252525),
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
                    Material(
                      color: Colors.transparent,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: IconButton(
                        icon: const Icon(Icons.menu),
                        iconSize: 28,
                        color: const Color(0xffcfcfcf),
                        onPressed: () {
                          collapsed
                              ? controller.forward()
                              : controller.reverse();
                          setState(() => collapsed = !collapsed);
                        },
                      ),
                    ),
                    if (!collapsed) ...[
                      const Expanded(child: SizedBox()),
                      Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        child: IconButton(
                          icon: const Icon(Icons.settings_outlined),
                          iconSize: 26,
                          color: const Color(0xffa8a8a8),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ));
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 15,
                      )
                    ]
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(
                    child: ListView(
                  children: [
                    Consumer<FileChangeNotifier>(
                      builder: (context, value, child) => DrawerItem(
                          dta: ItemData('All Notes', Icons.book),
                          collapsed: collapsed,
                          endText: value.tiledata.length.toString(),
                          active: widget.activePage == View.all,
                          onTap: () => widget.onPageChange(View.all)),
                    ),
                    DrawerItem(
                        dta: ItemData('Shared Notebooks', Icons.person_outline),
                        collapsed: collapsed,
                        active: widget.activePage == View.shared,
                        onTap: () => widget.onPageChange(View.shared)),
                    DrawerItem(
                        dta: ItemData(
                            'Recycle bin', FluentIcons.delete_20_filled),
                        collapsed: collapsed,
                        active: widget.activePage == View.recycle,
                        onTap: () => widget.onPageChange(View.recycle)),
                    DrawerItem(
                        dta: ItemData('Folders', Icons.folder_outlined),
                        collapsed: collapsed,
                        active: widget.activePage == View.folders,
                        onTap: () => widget.onPageChange(View.folders)),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
