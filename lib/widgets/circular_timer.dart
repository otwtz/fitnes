import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CircularTimer extends StatelessWidget {
  final double percent;
  final int seconds;
  final int totalSeconds;
  final bool isRest;

  const CircularTimer({
    super.key,
    required this.percent,
    required this.seconds,
    required this.totalSeconds,
    this.isRest = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 220,
            height: 220,
            child: CircularProgressIndicator(
              value: percent,
              strokeWidth: 16,
              backgroundColor: const Color(0xFFE0E0E0),
              valueColor: AlwaysStoppedAnimation<Color>(
                isRest ? const Color(0xFF4B7BEC) : const Color(0xFF23B676),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$seconds',
                style: GoogleFonts.montserrat(
                  fontSize: 56,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              Text(
                'sec',
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
} 