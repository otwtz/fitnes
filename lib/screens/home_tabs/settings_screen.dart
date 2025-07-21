import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class SettingsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appSettings = Provider.of<AppSettings>(context);
    final isDark = appSettings.themeMode == ThemeMode.dark;
    final vibrationEnabled = appSettings.vibrationEnabled;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Settings',
          style: GoogleFonts.montserrat(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Profile',
              style: GoogleFonts.montserrat(fontSize: 28, color: isDark ? Colors.white : Colors.black),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                appSettings.toggleTheme();
                if (appSettings.vibrationEnabled) HapticFeedback.lightImpact();
              },
              icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              label: Text(isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF4B7BEC) : const Color(0xFF232A2A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                appSettings.toggleVibration();
                if (appSettings.vibrationEnabled) HapticFeedback.lightImpact();
              },
              icon: Icon(vibrationEnabled ? Icons.vibration : Icons.vibration_outlined),
              label: Text(vibrationEnabled ? 'Disable Vibration' : 'Enable Vibration'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFFFCCA0E) : const Color(0xFF4B7BEC),
                foregroundColor: isDark ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                textStyle: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}