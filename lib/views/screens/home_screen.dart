import 'package:flutter/material.dart';
import 'package:local_notification/views/screens/motivation_screen.dart';
import 'package:local_notification/views/screens/todo_screen.dart';
import 'package:local_notification/views/screens/pomodoro_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectIndex = 0;
  List<Widget> pages = [
    const MotivationScreen(),
    const TodoScreen(),
    const PomodoroScreen(),
  ];

  void _onItemTab(int index) {
    setState(() {
      selectIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: selectIndex,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: "Motivation",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline_sharp),
            label: "Todo",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: "Pomodoro",
          ),
        ],
        currentIndex: selectIndex,
        onTap: _onItemTab,
        selectedItemColor: Colors.blue,
        selectedFontSize: 15,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Extrag',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
