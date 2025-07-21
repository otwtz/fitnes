import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/exercise.dart';
import 'home_tabs/home_screen.dart';
import 'home_tabs/programs_screen.dart';
import 'home_tabs/settings_screen.dart';
import 'home_tabs/stats_screen.dart';
import 'home_tabs/timer_screen.dart';
import 'timer_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    HomeTab(),
    TimersTab(),
    ProgramsTab(),
    StatsTab(),
    SettingsTab(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Column(
        children: [
          Expanded(child: _screens[_selectedIndex]),
          Container(
            height: 2,
            color: const Color(0xFFFCCA0E),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: isDark ? const Color(0xFF1F2424) : const Color(0xFFF5F6FA),
        selectedItemColor: const Color(0xFFFCCA0E),
        unselectedItemColor: isDark ? Colors.white70 : Colors.black54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _selectedIndex == 0 ? const Color(0xFFFCCA0E) : (isDark ? Colors.white70 : Colors.black54)),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined, color: _selectedIndex == 1 ? const Color(0xFFFCCA0E) : (isDark ? Colors.white70 : Colors.black54)),
            label: 'Timers',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_sharp, color: _selectedIndex == 2 ? const Color(0xFFFCCA0E) : (isDark ? Colors.white70 : Colors.black54)),
            label: 'Programs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart, color: _selectedIndex == 3 ? const Color(0xFFFCCA0E) : (isDark ? Colors.white70 : Colors.black54)),
            label: 'Stats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, color: _selectedIndex == 4 ? const Color(0xFFFCCA0E) : (isDark ? Colors.white70 : Colors.black54)),
            label: 'Settings',
          ),
        ],
        enableFeedback: false,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        mouseCursor: SystemMouseCursors.basic,
      ),
    );
  }
}









