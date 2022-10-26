import 'package:flutter/material.dart';
import 'package:notes/collapse_drawer.dart';
import 'package:notes/all_notes_page.dart';
import 'package:notes/canvas/drawing_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  View activePage = View.all;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _fab(),
      body: Row(
        children: [
          CollapseDrawer(
            onPageChange: (View newPage) =>
                setState(() => activePage = newPage),
            activePage: activePage,
          ),
          Expanded(
              child: Container(
            color: const Color(0xff0d0d0d),
            child: _buildPage(),
          ))
        ],
      ),
    );
  }

  Widget _fab() {
    switch (activePage) {
      case View.all:
      case View.folders:
        return FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const DrawingPage(),
              ),
            );
          },
          backgroundColor: const Color(0xff3f3f3f),
          child: const Icon(Icons.edit_calendar_outlined, color: Colors.orange),
        );
      default:
        return Container();
    }
  }

  Widget _buildPage() {
    switch (activePage) {
      case View.all:
        return const AllNotesPage();
      case View.shared:
        return const Text(
          'shared notebooks WIP',
          style: TextStyle(color: Colors.white),
        );
      case View.recycle:
        return const Text(
          'recycle bin WIP',
          style: TextStyle(color: Colors.white),
        );
      case View.folders:
        return const Text(
          'Folders WIP',
          style: TextStyle(color: Colors.white),
        );
    }
  }
}
