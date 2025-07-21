import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/exercise.dart';
import '../widgets/circular_timer.dart';
import 'finish_screen.dart';

class TimerScreen extends StatefulWidget {
  final Exercise exercise;

  const TimerScreen({super.key, required this.exercise});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

enum TimerPhase { interval, rest }

class _TimerScreenState extends State<TimerScreen> {
  late int currentCycle;
  late int secondsLeft;
  late TimerPhase phase;
  bool isRunning = false;
  Timer? timer;

  int get interval => widget.exercise.duration;
  int get rest => widget.exercise.rest;
  int get cycles => widget.exercise.cycles;

  @override
  void initState() {
    super.initState();
    currentCycle = 1;
    phase = TimerPhase.interval;
    secondsLeft = interval;
  }

  void startTimer() {
    setState(() {
      isRunning = true;
    });
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsLeft > 0) {
        setState(() {
          secondsLeft--;
        });
      } else {
        if (phase == TimerPhase.interval) {
          if (rest > 0) {
            setState(() {
              phase = TimerPhase.rest;
              secondsLeft = rest;
            });
          } else {
            nextCycleOrFinish();
          }
        } else {
          nextCycleOrFinish();
        }
      }
    });
  }

  void pauseTimer() {
    setState(() {
      isRunning = false;
    });
    timer?.cancel();
  }

  void nextPhase() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
    // Не используется, оставлено для совместимости с кнопкой "skip"
    if (phase == TimerPhase.interval) {
      if (rest > 0) {
        setState(() {
          phase = TimerPhase.rest;
          secondsLeft = rest;
        });
        startTimer();
      } else {
        nextCycleOrFinish();
      }
    } else {
      nextCycleOrFinish();
    }
  }

  void nextCycleOrFinish() {
    if (currentCycle < cycles) {
      setState(() {
        currentCycle++;
        phase = TimerPhase.interval;
        secondsLeft = interval;
      });
      startTimer();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => FinishScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final percent = secondsLeft / (phase == TimerPhase.interval ? interval : rest == 0 ? 1 : rest);
    final isRest = phase == TimerPhase.rest;
    final theme = Theme.of(context);
    final textColor = theme.brightness == Brightness.dark ? Colors.white : Colors.black;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              Text(
                widget.exercise.name,
                style: GoogleFonts.montserrat(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isRest ? 'Rest' : 'Interval',
                style: GoogleFonts.montserrat(
                  fontSize: 22,
                  color: isRest ? Colors.green : Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              CircularTimer(
                percent: percent,
                seconds: secondsLeft,
                totalSeconds: phase == TimerPhase.interval ? interval : rest,
                isRest: isRest,
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isRunning
                          ? const Color(0xFFFC5C7D)
                          : const Color(0xFF4B7BEC),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24),
                    ),
                    onPressed: () {
                      if (isRunning) {
                        pauseTimer();
                      } else {
                        startTimer();
                      }
                    },
                    child: Icon(
                      isRunning ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  const SizedBox(width: 32),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF53E0BC),
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(24),
                    ),
                    onPressed: nextPhase,
                    child: const Icon(
                      Icons.skip_next,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                'Cycle $currentCycle of $cycles',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: textColor.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 