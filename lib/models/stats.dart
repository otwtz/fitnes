import 'package:hive/hive.dart';
part 'stats.g.dart';

@HiveType(typeId: 1)
class DayStats extends HiveObject {
  @HiveField(0)
  String day; // e.g. 'Mon', 'Tue', ...

  @HiveField(1)
  int completed;

  @HiveField(2)
  DateTime? date;

  DayStats({required this.day, this.completed = 0, this.date});

  factory DayStats.fromMap(Map<String, dynamic> map) => DayStats(
        day: map['day'],
        completed: map['completed'] ?? 0,
        date: map['date'],
      );

  Map<String, dynamic> toMap() => {
        'day': day,
        'completed': completed,
        'date': date,
      };
} 