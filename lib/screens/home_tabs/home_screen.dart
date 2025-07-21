import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:treker/screens/home_tabs/programs_screen.dart';
import 'package:treker/screens/home_tabs/stats_screen.dart';
import 'package:provider/provider.dart';
import 'package:treker/screens/home_tabs/timer_screen.dart';
import '../../main.dart';
import '../../providers/exercise_provider.dart';
import '../../screens/timer_screen.dart';

class HomeTab extends StatefulWidget {
  final void Function(int)? onTabChange;

  const HomeTab({super.key, this.onTabChange});

  static const int maxTaps = 10;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final List<String> timerNames = ['Tabata 20/10, 5 cycles', 'Custom Cardio, 10 min', 'Abs Workout, 15 min'];

  final List<int> tapCounts = [0, 0, 0];

  void _addExercise() {
    setState(() {
      timerNames.add('Новое упражнение');
      tapCounts.add(0);
    });
  }

    void _addExerciseDialog() async {
    String newName = '';
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isDark ? const Color(0xFF1F2424) : Colors.white,
          title: Text(
            'New Timer', 
            style: GoogleFonts.montserrat(
              color: isDark ? Colors.white : Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: TextField(
            autofocus: true,
            style: GoogleFonts.montserrat(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: 'Add title',
              hintStyle: GoogleFonts.montserrat(color: isDark ? Colors.white70 : Colors.black54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: isDark ? Colors.white30 : Colors.black26),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: const Color(0xFFFCCA0E)),
              ),
            ),
            onChanged: (value) {
              newName = value;
            },
            onSubmitted: (value) {
              newName = value;
              Navigator.of(context).pop();
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(), 
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFCCA0E),
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Add',
                style: GoogleFonts.montserrat(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
    if (newName.trim().isNotEmpty) {
      setState(() {
        timerNames.add(newName.trim());
        tapCounts.add(0);
      });
    }
  }

  String _formattedDate() {
    final now = DateTime.now();
    final time = DateFormat('hh:mm a').format(now);
    final date = DateFormat('dd/MM/yyyy').format(now);
    return '$time Moscow, $date';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final background = theme.scaffoldBackgroundColor;
    final containerColor = isDark
        ? const Color(0xFF2A2F2F)
        : Color.alphaBlend(Colors.black.withOpacity(0.04), background);
    final textColor = isDark ? Colors.white : Colors.black;
    final subTextColor = isDark ? Colors.white70 : Colors.black54;
    final appSettings = Provider.of<AppSettings>(context, listen: false);
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Center(
          child: Text(
            'Workout Timers',
            style: GoogleFonts.montserrat(color: textColor, fontWeight: FontWeight.bold, fontSize: 24),
          ),
        ),
        actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () {})],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _formattedDate(),
              style: GoogleFonts.montserrat(color: subTextColor, fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: exerciseProvider.exercises.length,
                itemBuilder: (context, i) {
                  final ex = exerciseProvider.exercises[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Container(
                      width: double.infinity,
                      height: 92,
                      decoration: BoxDecoration(color: containerColor, borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  ex.name,
                                  style: GoogleFonts.montserrat(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    await exerciseProvider.incrementExercise(i);
                                    if (appSettings.vibrationEnabled) HapticFeedback.lightImpact();
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => TimerScreen(
                                          exercise: ex,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: isDark ? const Color(0xFF23B676) : const Color(0xFF4B7BEC),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  ),
                                  child: Text('Start', style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: ex.completedCount / 10.0,
                              backgroundColor: Colors.white12,
                              valueColor: AlwaysStoppedAnimation<Color>(isDark ? Color(0xFFFCCA0E) : Color(0xFF4B7BEC)),
                              minHeight: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => TimersTab()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFFFCCA0E) : const Color(0xFF4B7BEC),
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Add Timer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProgramsTab())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFFFCCA0E) : const Color(0xFF4B7BEC),
                        foregroundColor: isDark ? Colors.black : Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Programs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => StatsTab())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isDark ? const Color(0xFF23B676) : const Color(0xFFFCCA0E),
                        foregroundColor: isDark ? Colors.white : Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text('Stats', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: textColor)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
