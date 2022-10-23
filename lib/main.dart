import 'package:flutter/material.dart';
import 'package:notes/CollapseDrawer.dart';
import 'package:notes/all_notes_page.dart';

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
      body: Row(
        children: [
          CollapseDrawer(
              onPageChange: (View newPage) =>
                  setState(() => activePage = newPage), activePage: activePage,),
          Expanded(
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, .95),
                child: _buildPage(),
              ))
        ],
      ),
    );
  }

  Widget _buildPage() {
    switch (activePage) {
      case View.all:
        return const AllNotesPage();
      case View.shared:
        return const Text("Todo1", style: TextStyle(color: Colors.white),);
      case View.recycle:
        return const Text("Todo", style: TextStyle(color: Colors.white),);
      case View.folders:
        return const Text("Todo", style: TextStyle(color: Colors.white),);
    }
  }
}
