import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../context/file_change_notifier.dart';
import '../widgets/icon_material_button.dart';
import '../widgets/note_tile.dart';

class AllNotesPage extends StatefulWidget {
  const AllNotesPage({Key? key}) : super(key: key);

  @override
  State<AllNotesPage> createState() => _AllNotesPageState();
}

class _AllNotesPageState extends State<AllNotesPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 25 + MediaQuery.of(context).viewPadding.top,
        ),
        Row(
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
              },
              iconSize: 22,
            ),
            IconMaterialButton(
              icon: const Icon(Icons.search),
              color: const Color.fromRGBO(255, 255, 255, .85),
              onPressed: () {},
              iconSize: 22,
            ),
            IconMaterialButton(
              icon: const Icon(Icons.more_vert),
              color: const Color.fromRGBO(255, 255, 255, .85),
              onPressed: () {},
              iconSize: 22,
            ),
            const SizedBox(
              width: 15,
            )
          ],
        ),
        Row(
          children: const [Text('date modified..')],
        ),
        _buildNoteTiles()
      ],
    );
  }

  Widget _buildNoteTiles() {
    return Expanded(
      child: Consumer<FileChangeNotifier>(
        builder: (BuildContext context, value, Widget? child) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
            ),
            padding: const EdgeInsets.all(2),
            itemBuilder: (BuildContext context, int idx) =>
                NoteTile(data: value.tiledata[idx]),
            itemCount: value.tiledata.length,
          );
        },
      ),
    );
  }
}
