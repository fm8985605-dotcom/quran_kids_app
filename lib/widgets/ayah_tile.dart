import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/ayah_model.dart';
import '../theme/app_theme.dart';

class AyahTile extends StatelessWidget {
  final Ayah ayah;
  final bool isPlaying;
  final int currentRepeat;
  final int targetRepeat;
  final VoidCallback onPlayTap;
  final VoidCallback onRecordTap;

  const AyahTile({
    Key? key,
    required this.ayah,
    required this.isPlaying,
    required this.currentRepeat,
    required this.targetRepeat,
    required this.onPlayTap,
    required this.onRecordTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPlaying ? AppTheme.secondaryColor.withOpacity(0.15) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isPlaying ? AppTheme.secondaryColor : Colors.transparent,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isPlaying ? AppTheme.secondaryColor.withOpacity(0.2) : Colors.black.withOpacity(0.04),
            blurRadius: isPlaying ? 12 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Ayah Header bar with controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Ayah Number badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isPlaying ? AppTheme.primaryColor : AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'آية ${ayah.numberInSurah}',
                  style: GoogleFonts.cairo(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isPlaying ? Colors.white : AppTheme.primaryColor,
                  ),
                ),
              ),

              if (isPlaying)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppTheme.mintGreen,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.repeat_rounded, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        'التكرار: ${currentRepeat + 1} من $targetRepeat',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

              // Action buttons (Play & Record)
              Row(
                children: [
                  // Record child's voice button
                  IconButton(
                    onPressed: onRecordTap,
                    icon: const Icon(Icons.mic_rounded, color: AppTheme.coralRed),
                    tooltip: 'سجّل صوتك وقارنه بالشيخ',
                  ),
                  // Play single Ayah button
                  IconButton(
                    onPressed: onPlayTap,
                    icon: Icon(
                      isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Quran Ayah Text in Amiri Font
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              ayah.text,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: GoogleFonts.amiri(
                fontSize: 26,
                height: 2.0,
                fontWeight: FontWeight.bold,
                color: isPlaying ? const Color(0xFF1E272C) : const Color(0xFF2D3436),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
