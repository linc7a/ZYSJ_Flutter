import 'package:flutter/material.dart';

import 'pages/change_log_page.dart';
import 'pages/hello_lab_page.dart';
import 'pages/tetris_page.dart';

void main() {
  runApp(const TeamCollabApp());
}

class TeamCollabApp extends StatelessWidget {
  const TeamCollabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team Collab Lab',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        useMaterial3: true,
      ),
      home: const HomeShell(),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;

  static const _pages = [
    HelloLabPage(),
    TetrisPage(),
    ChangeLogPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Collab Lab'),
        centerTitle: false,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.code_rounded),
            label: 'Hello',
          ),
          NavigationDestination(
            icon: Icon(Icons.grid_view_rounded),
            label: 'Tetris',
          ),
          NavigationDestination(
            icon: Icon(Icons.fact_check_rounded),
            label: 'Logs',
          ),
        ],
      ),
    );
  }
}
