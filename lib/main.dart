import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'screens/splash_screen.dart';
import 'models/exercise.dart';
import 'models/stats.dart';
import 'providers/exercise_provider.dart';

class AppSettings extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;
  bool vibrationEnabled = true;

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void toggleVibration() {
    vibrationEnabled = !vibrationEnabled;
    notifyListeners();
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(DayStatsAdapter());
  await Hive.openBox<Exercise>('exercises');
  await Hive.openBox<DayStats>('stats');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettings()),
        ChangeNotifierProvider(create: (_) => ExerciseProvider()),
      ],
      child: const FitnessTimerApp(),
    ),
  );
}

class FitnessTimerApp extends StatelessWidget {
  const FitnessTimerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppSettings>(
      builder: (context, settings, _) {
        return MaterialApp(
          title: 'Fitness Timer',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFFF5F6FA),
            iconTheme: const IconThemeData(color: Color(0xFFFCCA0E)),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Color(0xFFFCCA0E),
            ),
            iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all(const Color(0xFFFCCA0E)),
              ),
            ),
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'Montserrat',
                ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF1F2424),
            iconTheme: const IconThemeData(color: Color(0xFFFCCA0E)),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Color(0xFFFCCA0E),
            ),
            iconButtonTheme: IconButtonThemeData(
              style: ButtonStyle(
                iconColor: MaterialStateProperty.all(const Color(0xFFFCCA0E)),
              ),
            ),
            textTheme: Theme.of(context).textTheme.apply(
                  fontFamily: 'Montserrat',
                ),
          ),
          themeMode: settings.themeMode,
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
