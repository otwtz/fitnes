import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProgramsTab extends StatelessWidget {
  final List<Program> programs = [
    Program(
      name: 'Abs Workout, 15 min',
      description: 'Target core muscles with 3 effectiveexercises.',
      image: 'assets/Plank illustration.png',
    ),
    Program(
      name: 'Cardio Blast, 30 min',
      description: 'High-intensity cardio to boost endurance.',
      image: 'assets/Cardio illustration.png',
    ),
    Program(
      name: 'Full Body, 45 min',
      description: 'Comprehensive workout for all majormuscle groups.',
      image: 'assets/Full Body illustration.png',
    ),
    Program(
      name: 'HIIT, 20 min',
      description: 'Short, intense intervals for maximum calorieburn.',
      image: 'assets/HIIT illustration.png',
    ),
    Program(
      name: 'Yoga Flow, 60 min',
      description: 'Improve flexibility and mindfulness withgentle poses.',
      image: 'assets/Yoga illustration.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final backgroundColor = isDark ? const Color(0xFF1F2424) : const Color(0xFFF5F6FA);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Icon(Icons.arrow_back_ios_new, color: const Color(0xFFFCCA0E)),
        elevation: 0,
        title: Center(
          child: Text(
            'Workout Programs',
            style: GoogleFonts.montserrat(color: textColor, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: null, // Неактивная кнопка
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFCCA0E),
                disabledBackgroundColor: const Color(0xFFFCCA0E),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white, size: 18),
                  const SizedBox(width: 12),
                  Text(
                    'Create Custom',
                    style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
                     Text(
             'Pre-made Programs',
             style: GoogleFonts.montserrat(color: textColor, fontWeight: FontWeight.w700, fontSize: 20),
           ),
          const SizedBox(height: 12),
          ...programs
              .map(
                (program) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildProgramCard(context, program, textColor),
                ),
              )
              .toList(),
        ],
      ),
    );
  }

  Widget _buildProgramCard(BuildContext context, Program program, Color textColor) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFCCA0E).withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Center(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:  BorderRadius.circular(20),
                  border: Border.all(width: 1, color: const Color(0xFFFCCA0E)),
                ),
                child: ClipRRect(
                  borderRadius:  BorderRadius.circular(20),

                  child: Image.asset(
                    program.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(Icons.fitness_center, size: 60, color: Colors.grey[600]),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  program.name,
                  style: GoogleFonts.montserrat(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  program.description,
                  style: GoogleFonts.montserrat(fontSize: 14, color: textColor.withOpacity(0.7), height: 1.4),
                ),
                const SizedBox(height: 16),

                // Start Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Implement program start functionality
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Starting ${program.name}...', style: GoogleFonts.montserrat()),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: Text(
                        'Start',
                        style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Program {
  final String name;
  final String description;
  final String image;

  Program({required this.name, required this.description, required this.image});
}
