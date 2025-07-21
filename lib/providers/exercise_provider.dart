import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/exercise.dart';
import '../models/stats.dart';

class ExerciseProvider extends ChangeNotifier {
  List<Exercise> _exercises = [];
  List<DayStats> _stats = [];

  List<Exercise> get exercises => _exercises;
  List<DayStats> get stats => _stats;

  ExerciseProvider() {
    _loadExercises();
    _loadStats();
  }

  Future<void> _loadExercises() async {
    final box = Hive.box<Exercise>('exercises');
    _exercises = box.values.toList();
    notifyListeners();
  }

  Future<void> _loadStats() async {
    final box = Hive.box<DayStats>('stats');
    _stats = box.values.toList();
    if (_stats.length < 7) {
      // Ensure all days are present
      const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      for (final d in days) {
        if (!_stats.any((s) => s.day == d)) {
          final stat = DayStats(day: d, completed: 0);
          await box.add(stat);
          _stats.add(stat);
        }
      }
    }
    notifyListeners();
  }

  Future<void> addExercise(Exercise exercise) async {
    final box = Hive.box<Exercise>('exercises');
    await box.add(exercise);
    _exercises = box.values.toList();
    notifyListeners();
  }

  Future<void> incrementExercise(int index) async {
    final box = Hive.box<Exercise>('exercises');
    final exercise = _exercises[index];
    exercise.completedCount++;
    await exercise.save();
    _exercises = box.values.toList();
    await _incrementDayStat();
    notifyListeners();
  }

  Future<void> _incrementDayStat() async {
    final box = Hive.box<DayStats>('stats');
    final now = DateTime.now();
    final weekday = now.weekday; // 1=Mon, 7=Sun
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final day = days[weekday - 1];
    final stat = _stats.firstWhere((s) => s.day == day);
    stat.completed++;
    stat.date = now;
    await stat.save();
    _stats = box.values.toList();
    notifyListeners();
  }

  Future<void> addExerciseAndNotify(Exercise exercise) async {
    await addExercise(exercise);
    notifyListeners();
  }

  Future<void> resetStats() async {
    final box = Hive.box<DayStats>('stats');
    await box.clear();
    
    // Reset all day stats to 0
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (final d in days) {
      final stat = DayStats(day: d, completed: 0);
      await box.add(stat);
    }
    
    _stats = box.values.toList();
    notifyListeners();
  }
} 