import 'package:hive/hive.dart';
part 'exercise.g.dart';

@HiveType(typeId: 0)
class Exercise extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int duration; // seconds

  @HiveField(2)
  int completedCount;

  @HiveField(3)
  int rest;

  @HiveField(4)
  int cycles;

  Exercise({
    required this.name,
    required this.duration,
    this.completedCount = 0,
    this.rest = 10,
    this.cycles = 1,
  });

  factory Exercise.fromMap(Map<String, dynamic> map) => Exercise(
        name: map['name'],
        duration: map['duration'],
        completedCount: map['completedCount'] ?? 0,
        rest: map['rest'] ?? 10,
        cycles: map['cycles'] ?? 1,
      );

  Map<String, dynamic> toMap() => {
        'name': name,
        'duration': duration,
        'completedCount': completedCount,
        'rest': rest,
        'cycles': cycles,
      };
} 