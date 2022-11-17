import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../context/file_change_notifier.dart';
import '../savesystem/note_file.dart';
import '../widgets/icon_material_button.dart';
import '../widgets/icon_text_button.dart';
import '../widgets/note_tile.dart';
import '../widgets/wip_toast.dart';

class AllNotesPage extends StatefulWidget {
  const AllNotesPage({Key? key}) : super(key: key);

  @override
  State<AllNotesPage> createState() => _AllNotesPageState();
}

class _AllNotesPageState extends State<AllNotesPage> {
  FToast fToast = FToast();
  bool selectionMode = false;
  List<int> selectionIdx = [];

  @override
  void initState() {
    super.initState();
    fToast.init(context);
  }

  Widget _buildTopBar() {
    if (selectionMode) {
      return Row(
        children: [
          const SizedBox(
            width: 20,
            height: 40,
          ),
          Text(
            '${selectionIdx.length} selected',
            style: const TextStyle(
                color: Color.fromRGBO(255, 255, 255, .85), fontSize: 21),
          )
        ],
      );
    } else {
      return Row(
        children: [
          const SizedBox(
            width: 20,
          ),
          const Text(
            'All notes',
            style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, .85), fontSize: 21),
          ),
          Expanded(child: Container()),
          IconMaterialButton(
            icon: const Icon(Icons.picture_as_pdf_outlined),
            color: const Color.fromRGBO(255, 255, 255, .85),
            onPressed: () async {
              // todo implement pdf import
              fToast.showToast(
                child: const WIPToast(),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );
            },
            iconSize: 22,
          ),
          IconMaterialButton(
            icon: const Icon(Icons.search),
            color: const Color.fromRGBO(255, 255, 255, .85),
            onPressed: () {
              fToast.showToast(
                child: const WIPToast(),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );
            },
            iconSize: 22,
          ),
          IconMaterialButton(
            icon: const Icon(Icons.more_vert),
            color: const Color.fromRGBO(255, 255, 255, .85),
            onPressed: () {
              fToast.showToast(
                child: const WIPToast(),
                gravity: ToastGravity.BOTTOM,
                toastDuration: const Duration(seconds: 2),
              );
            },
            iconSize: 22,
          ),
          const SizedBox(
            width: 15,
          )
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 25 + MediaQuery.of(context).viewPadding.top,
        ),
        _buildTopBar(),
        Row(
          children: const [
            SizedBox(
              height: 18,
            )
          ],
        ),
        _buildNoteTiles(),
        if (selectionMode)
          SizedBox(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconTextButton(
                  icon: const Icon(Icons.drive_file_move_outline),
                  color: const Color.fromRGBO(255, 255, 255, .85),
                  onPressed: () {
                    fToast.showToast(
                      child: const WIPToast(),
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: const Duration(seconds: 2),
                    );
                  },
                  iconSize: 24,
                  text: 'Move',
                ),
                IconTextButton(
                  icon: const Icon(Icons.lock_outline),
                  color: const Color.fromRGBO(255, 255, 255, .85),
                  onPressed: () {
                    fToast.showToast(
                      child: const WIPToast(),
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: const Duration(seconds: 2),
                    );
                  },
                  iconSize: 24,
                  text: 'Lock',
                ),
                IconTextButton(
                  icon: const Icon(Icons.share),
                  color: const Color.fromRGBO(255, 255, 255, .85),
                  onPressed: () {
                    fToast.showToast(
                      child: const WIPToast(),
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: const Duration(seconds: 2),
                    );
                  },
                  iconSize: 24,
                  text: 'Share',
                ),
                IconTextButton(
                  icon: const Icon(FluentIcons.delete_20_filled),
                  color: const Color.fromRGBO(255, 255, 255, .85),
                  onPressed: () async {
                    // todo add popup to ask if really delete

                    final filechangenotfier =
                        Provider.of<FileChangeNotifier>(context, listen: false);
                    for (final s in selectionIdx) {
                      final dta = filechangenotfier.tiledata[s];
                      // todo maybe optimize a bit and create not always new notefile instance
                      await NoteFile(dta.relativePath).delete();
                    }

                    await filechangenotfier.loadAllNotes();

                    setState(() {
                      selectionIdx = [];
                      selectionMode = false;
                    });
                  },
                  iconSize: 24,
                  text: 'Delete',
                ),
                IconTextButton(
                  icon: const Icon(Icons.more_vert),
                  color: const Color.fromRGBO(255, 255, 255, .85),
                  onPressed: () {
                    fToast.showToast(
                      child: const WIPToast(),
                      gravity: ToastGravity.BOTTOM,
                      toastDuration: const Duration(seconds: 2),
                    );
                  },
                  iconSize: 24,
                  text: 'More',
                ),
              ],
            ),
          )
      ],
    );
  }

  Widget _buildNoteTiles() {
    return Consumer<FileChangeNotifier>(
      builder: (BuildContext context, value, Widget? child) {
        return Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6, childAspectRatio: 0.7),
            physics: const ScrollPhysics(),
            padding: const EdgeInsets.all(2),
            itemBuilder: (BuildContext context, int idx) => NoteTile(
              data: value.tiledata[idx],
              selectionMode: selectionMode,
              selected: selectionIdx.contains(idx),
              onSelectionChange: (selection) {
                if (selection) {
                  if (!selectionMode) {
                    setState(() {
                      selectionMode = true;
                    });
                  }
                  if (!selectionIdx.contains(idx)) {
                    final sel = selectionIdx;
                    sel.add(idx);
                    setState(() {
                      selectionIdx = sel;
                    });
                  }
                } else {
                  final sel = selectionIdx;
                  sel.remove(idx);
                  if (sel.isEmpty) {
                    setState(() {
                      selectionMode = false;
                    });
                  }
                  setState(() {
                    selectionIdx = sel;
                  });
                }
              },
            ),
            itemCount: value.tiledata.length,
          ),
        );
      },
    );
  }
}
