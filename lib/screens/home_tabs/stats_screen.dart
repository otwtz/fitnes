import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../models/stats.dart';
import '../../providers/exercise_provider.dart';
import 'dart:math';

class StatsTab extends StatefulWidget {
  @override
  State<StatsTab> createState() => _StatsTabState();
}

class _StatsTabState extends State<StatsTab> {
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  bool _showCalendar = false;

  @override
  Widget build(BuildContext context) {
    final exerciseProvider = Provider.of<ExerciseProvider>(context);
    final stats = exerciseProvider.stats;
    final exercises = exerciseProvider.exercises;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final barColor = isDark ? const Color(0xFFFCCA0E) : const Color(0xFF4B7BEC);
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final values = days
        .map((d) => stats.firstWhere((s) => s.day == d, orElse: () => DayStats(day: d, completed: 0)).completed)
        .toList();

    // --- Week bar chart ---
    // Группировка по неделям
    Map<String, double> weekMap = {};
    for (final stat in stats) {
      if (stat.date == null) continue;
      // Если выбран период — фильтруем
      if (_rangeStart != null && _rangeEnd != null) {
        if (stat.date!.isBefore(_rangeStart!) || stat.date!.isAfter(_rangeEnd!)) continue;
      }
      final weekYear = '${stat.date!.year}-W${weekNumber(stat.date!)}';
      weekMap[weekYear] =
          (weekMap[weekYear] ?? 0) +
          exercises.fold(0.0, (sum, ex) => sum + ex.duration * ex.cycles * stat.completed / 3600.0);
    }
    final weekLabels = weekMap.keys.toList()..sort();
    final weekTotals = weekLabels.map((k) => weekMap[k] ?? 0).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Stats',
          style: GoogleFonts.montserrat(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_showCalendar)
              Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2100, 12, 31),
                    focusedDay: _rangeStart ?? DateTime.now(),
                    calendarFormat: _calendarFormat,
                    rangeStartDay: _rangeStart,
                    rangeEndDay: _rangeEnd,
                    onFormatChanged: (f) => setState(() => _calendarFormat = f),
                    onRangeSelected: (start, end, focused) {
                      setState(() {
                        _rangeStart = start;
                        _rangeEnd = end;
                      });
                    },
                    rangeSelectionMode: RangeSelectionMode.enforced,
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(color: barColor, shape: BoxShape.circle),
                      rangeHighlightColor: barColor.withOpacity(0.3),
                      defaultTextStyle: GoogleFonts.montserrat(color: textColor),
                      weekendTextStyle: GoogleFonts.montserrat(color: textColor),
                    ),
                    headerStyle: HeaderStyle(
                      titleTextStyle: GoogleFonts.montserrat(color: textColor, fontWeight: FontWeight.bold),
                      formatButtonTextStyle: GoogleFonts.montserrat(color: textColor),
                      formatButtonDecoration: BoxDecoration(color: barColor, borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _showCalendar = false;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: barColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            'Apply',
                            style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _showCalendar = false;
                              _rangeStart = null;
                              _rangeEnd = null;
                            });
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: barColor),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.montserrat(color: barColor, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            if (!_showCalendar)
              Container(
                width: double.infinity,
                height: 47,
                decoration: BoxDecoration(
                  border: Border.all(width: 1, color: const Color(0xFFFCCA0E)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          _getDateRangeText(),
                          style: GoogleFonts.montserrat(
                            color: Color(0xFFFCCA0E),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        color: textColor,
                        onPressed: () {
                          setState(() {
                            _showCalendar = !_showCalendar;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 1, color: const Color(0xFFFCCA0E)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Workouts per Week',
                      style: GoogleFonts.montserrat(fontSize: 20, color: textColor, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: (values.reduce((a, b) => a > b ? a : b).toDouble() + 1).clamp(4, 20),
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  return idx >= 0 && idx < days.length
                                      ? Padding(
                                          padding: const EdgeInsets.only(top: 8.0),
                                          child: Text(days[idx], style: GoogleFonts.montserrat(color: textColor)),
                                        )
                                      : const SizedBox.shrink();
                                },
                                interval: 1,
                              ),
                            ),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(days.length, (i) {
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: values[i].toDouble(),
                                  color: barColor,
                                  width: 22,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            );
                          }),
                          gridData: FlGridData(show: false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(width: 1, color: const Color(0xFFFCCA0E)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Time',
                      style: GoogleFonts.montserrat(fontSize: 20, color: textColor, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 220,
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: ((weekTotals.isNotEmpty ? weekTotals.reduce((a, b) => a > b ? a : b) + 1 : 4).clamp(
                            4,
                            20,
                          )).toDouble(),
                          barTouchData: BarTouchData(enabled: false),
                          titlesData: FlTitlesData(
                            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  return idx >= 0 && idx < weekLabels.length
                                      ? Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Text(weekLabels[idx], style: GoogleFonts.montserrat(color: textColor)),
                                  )
                                      : const SizedBox.shrink();
                                },
                                interval: 1,
                              ),
                            ),
                            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(weekLabels.length, (i) {
                            return BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: weekTotals[i],
                                  color: barColor,
                                  width: 22,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ],
                            );
                          }),
                          gridData: FlGridData(show: false),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _showResetConfirmation(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF251F11),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Reset Stats',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement export functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Export functionality coming soon!',
                            style: GoogleFonts.montserrat(),
                          ),
                          backgroundColor: barColor,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: barColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),

                    child: Text(
                      'Export Data',
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showResetConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).brightness == Brightness.dark 
              ? Colors.grey[900] 
              : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            'Reset Statistics',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Colors.black,
            ),
          ),
          content: Text(
            'Are you sure you want to reset all statistics? This action cannot be undone.',
            style: GoogleFonts.montserrat(
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white70 
                  : Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: GoogleFonts.montserrat(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white70 
                      : Colors.black87,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _resetStats();
              },
              child: Text(
                'Reset',
                style: GoogleFonts.montserrat(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _resetStats() {
    final exerciseProvider = Provider.of<ExerciseProvider>(context, listen: false);
    exerciseProvider.resetStats();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Statistics have been reset successfully!',
          style: GoogleFonts.montserrat(),
        ),
        backgroundColor: const Color(0xFFFCCA0E),
      ),
    );
  }

  String _getDateRangeText() {
    if (_rangeStart == null && _rangeEnd == null) {
      return 'All time';
    }

    if (_rangeStart != null && _rangeEnd != null) {
      final startMonth = _getMonthName(_rangeStart!.month);
      final endMonth = _getMonthName(_rangeEnd!.month);

      if (_rangeStart!.year == _rangeEnd!.year) {
        if (_rangeStart!.month == _rangeEnd!.month) {
          return '${startMonth} ${_rangeStart!.day} - ${_rangeEnd!.day}, ${_rangeStart!.year}';
        } else {
          return '${startMonth} ${_rangeStart!.day} - ${endMonth} ${_rangeEnd!.day}, ${_rangeStart!.year}';
        }
      } else {
        return '${startMonth} ${_rangeStart!.day}, ${_rangeStart!.year} - ${endMonth} ${_rangeEnd!.day}, ${_rangeEnd!.year}';
      }
    }

    if (_rangeStart != null) {
      final startMonth = _getMonthName(_rangeStart!.month);
      return 'From ${startMonth} ${_rangeStart!.day}, ${_rangeStart!.year}';
    }

    if (_rangeEnd != null) {
      final endMonth = _getMonthName(_rangeEnd!.month);
      return 'Until ${endMonth} ${_rangeEnd!.day}, ${_rangeEnd!.year}';
    }

    return 'All time';
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }
}

int weekNumber(DateTime date) {
  final firstDayOfYear = DateTime(date.year, 1, 1);
  final daysOffset = firstDayOfYear.weekday - 1;
  final firstMonday = firstDayOfYear.subtract(Duration(days: daysOffset));
  return ((date.difference(firstMonday).inDays) / 7).ceil();
}
