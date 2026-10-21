import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/audio_player_service.dart';
import '../theme/app_theme.dart';

class PlayerControlsBar extends StatelessWidget {
  final AudioPlayerService playerService;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const PlayerControlsBar({
    Key? key,
    required this.playerService,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Repetition setting bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.tune_rounded, size: 20, color: AppTheme.primaryColor),
                    const SizedBox(width: 8),
                    Text(
                      'تكرار الآية للتحفيظ:',
                      style: GoogleFonts.cairo(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
                // Repeat Count Chips: 1, 2, 3, 5 مرات
                Row(
                  children: [1, 2, 3, 5].map((count) {
                    final isSelected = playerService.repeatCountPerAyah == count;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: InkWell(
                        onTap: () => playerService.setRepeatCount(count),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.secondaryColor : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$count×',
                            style: GoogleFonts.cairo(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? Colors.black87 : Colors.grey[700],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Main playback buttons: Previous, Play/Pause, Next
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Previous Ayah
                IconButton(
                  onPressed: onPrevious,
                  icon: const Icon(Icons.skip_previous_rounded),
                  iconSize: 36,
                  color: AppTheme.primaryColor,
                  tooltip: 'الآية السابقة',
                ),

                // Play / Pause / Loading button
                playerService.isLoading
                    ? const SizedBox(
                        width: 56,
                        height: 56,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(color: AppTheme.primaryColor),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          if (playerService.isPlaying) {
                            playerService.pause();
                          } else {
                            playerService.resume();
                          }
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0x404A90E2),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            playerService.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white,
                            size: 38,
                          ),
                        ),
                      ),

                // Next Ayah
                IconButton(
                  onPressed: onNext,
                  icon: const Icon(Icons.skip_next_rounded),
                  iconSize: 36,
                  color: AppTheme.primaryColor,
                  tooltip: 'الآية التالية',
                ),

                // Loop Entire Surah Toggle
                IconButton(
                  onPressed: () => playerService.toggleRepeatEntireSurah(),
                  icon: Icon(
                    Icons.repeat_on_rounded,
                    color: playerService.repeatEntireSurah ? AppTheme.accentColor : Colors.grey,
                  ),
                  iconSize: 28,
                  tooltip: 'تكرار السورة كاملة',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
