import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../models/exercise.dart';
import '../../providers/exercise_provider.dart';
import '../../widgets/circular_timer.dart';

class TimersTab extends StatefulWidget {
  @override
  State<TimersTab> createState() => _TimersTabState();
}

class _TimersTabState extends State<TimersTab> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  int interval = 30;
  int rest = 10;
  int cycles = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;
    final borderColor = const Color(0xFFFCCA0E);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Center(child: Text('Create New Timer', style: GoogleFonts.montserrat(color: textColor,fontWeight: FontWeight.bold))),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Timer Name',
                      style: GoogleFonts.montserrat(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8,),
                    TextFormField(
                      initialValue: name,
                      decoration: InputDecoration(
                        labelStyle: GoogleFonts.montserrat(color: textColor),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: borderColor, width: 2),
                        ),
                      ),
                      style: GoogleFonts.montserrat(color: textColor),
                      onChanged: (v) => setState(() => name = v),
                      validator: (v) => v == null || v.isEmpty ? 'Enter name' : null,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: interval.toString(),
                          decoration: InputDecoration(
                            labelText: 'Work (sec)',
                            labelStyle: GoogleFonts.montserrat(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: borderColor, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: borderColor, width: 2),
                            ),
                          ),
                          style: GoogleFonts.montserrat(color: textColor),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => setState(() => interval = int.tryParse(v) ?? 0),
                          validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Enter interval' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          initialValue: rest.toString(),
                          decoration: InputDecoration(
                            labelText: 'Rest (sec)',
                            labelStyle: TextStyle(color: textColor,fontWeight: FontWeight.bold,fontSize: 16),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: borderColor, width: 2),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: borderColor, width: 2),
                            ),
                          ),
                          style: TextStyle(color: textColor),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => setState(() => rest = int.tryParse(v) ?? 0),
                          validator: (v) => (int.tryParse(v ?? '') ?? 0) < 0 ? 'Enter rest' : null,
                        ),
                      ),

                    ],
                  ),
                ),
                TextFormField(
                  initialValue: cycles.toString(),
                  decoration: InputDecoration(
                    labelText: 'Cycles',
                    labelStyle: TextStyle(color: textColor,fontWeight: FontWeight.bold,fontSize: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: borderColor, width: 2),
                    ),
                  ),
                  style: TextStyle(color: textColor),
                  keyboardType: TextInputType.number,
                  onChanged: (v) => setState(() => cycles = int.tryParse(v) ?? 1),
                  validator: (v) => (int.tryParse(v ?? '') ?? 0) <= 0 ? 'Enter cycles' : null,
                ),
                const SizedBox(height: 24),
                Text('Timer Preview', style: GoogleFonts.montserrat(fontSize: 18, color: textColor, fontWeight: FontWeight.w600)),
                TimerPreview(duration: interval, rest: rest, cycles: cycles, textColor: textColor),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF251F11),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Cancel',style: TextStyle(color: Colors.white),),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final provider = Provider.of<ExerciseProvider>(context, listen: false);
                              await provider.addExercise(Exercise(
                                name: name,
                                duration: interval,
                                rest: rest,
                                cycles: cycles,
                              ));
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFCCA0E),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Save'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TimerPreview extends StatelessWidget {
  final int duration;
  final int rest;
  final int cycles;
  final Color textColor;
  const TimerPreview({super.key, required this.duration, required this.rest, required this.cycles, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      width: 180,
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xFF23B676),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          '$duration sec',
          style: GoogleFonts.montserrat(
            color: textColor,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}