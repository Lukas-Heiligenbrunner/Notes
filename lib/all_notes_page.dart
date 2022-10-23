import 'package:flutter/material.dart';

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
        const SizedBox(
          height: 10,
        ),
        Row(
          children: [
            const SizedBox(
              width: 20,
            ),
            const Text(
              "All notes",
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, .85), fontSize: 22),
            ),
            Expanded(child: Container()),
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: IconButton(
                icon: const Icon(Icons.picture_as_pdf_outlined),
                iconSize: 28,
                color: const Color.fromRGBO(255, 255, 255, .85),
                onPressed: () {},
              ),
            ),
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: IconButton(
                icon: const Icon(Icons.search),
                iconSize: 28,
                color: const Color.fromRGBO(255, 255, 255, .85),
                onPressed: () {},
              ),
            ),
            Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: IconButton(
                icon: const Icon(Icons.more_vert),
                iconSize: 28,
                color: const Color.fromRGBO(255, 255, 255, .85),
                onPressed: () {},
              ),
            ),
            const SizedBox(
              width: 15,
            )
          ],
        ),
      ],
    );
  }
}
