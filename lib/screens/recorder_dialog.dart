import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/ayah_model.dart';
import '../services/recorder_service.dart';
import '../services/audio_player_service.dart';
import '../providers/rewards_provider.dart';
import '../theme/app_theme.dart';

class RecorderDialog extends StatefulWidget {
  final Ayah ayah;

  const RecorderDialog({Key? key, required this.ayah}) : super(key: key);

  static void show(BuildContext context, Ayah ayah) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RecorderDialog(ayah: ayah),
    );
  }

  @override
  State<RecorderDialog> createState() => _RecorderDialogState();
}

class _RecorderDialogState extends State<RecorderDialog> with SingleTickerProviderStateMixin {
  late final RecorderService _recorderService;
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _recorderService = RecorderService();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _recorderService.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _recorderService,
      builder: (context, _) {
        final isRecording = _recorderService.isRecording;
        final hasRecording = _recorderService.hasRecording;
        final isPlayingRecorded = _recorderService.isPlayingRecorded;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Modal Drag Handle
                Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),

                // Dialog Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.stars_rounded, color: AppTheme.secondaryColor, size: 28),
                    const SizedBox(width: 8),
                    Text(
                      'سجّل تلاوتك يا بطل! 🎙️',
                      style: GoogleFonts.cairo(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // The Ayah Box to Read
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'آية رقم ${widget.ayah.numberInSurah}',
                        style: GoogleFonts.cairo(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.ayah.text,
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.rtl,
                        style: GoogleFonts.amiri(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          height: 1.8,
                          color: const Color(0xFF2D3436),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Status Message for Child
                Text(
                  isRecording
                      ? 'جاري التسجيل... اقرأ الآية بوضوح وتأنٍ'
                      : hasRecording
                          ? 'أحسنت! تم تسجيل صوتك بنجاح'
                          : 'اضغط على الميكروفون وابدأ القراءة',
                  style: GoogleFonts.cairo(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isRecording ? AppTheme.coralRed : Colors.grey[700],
                  ),
                ),

                const SizedBox(height: 20),

                // Big Child-Friendly Record Button
                ScaleTransition(
                  scale: isRecording ? Tween(begin: 1.0, end: 1.15).animate(_pulseController) : const AlwaysStoppedAnimation(1.0),
                  child: GestureDetector(
                    onTap: () async {
                      if (isRecording) {
                        await _recorderService.stopRecording();
                        // Reward stars when child finishes recording
                        if (context.mounted) {
                          context.read<RewardsProvider>().addStars(3);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'ما شاء الله! حصلت على 3 نجوم لتلاوتك العطرة ⭐⭐⭐',
                                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                              ),
                              backgroundColor: AppTheme.mintGreen,
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        }
                      } else {
                        await _recorderService.startRecording(
                          widget.ayah.surahNumber,
                          widget.ayah.numberInSurah,
                        );
                      }
                    },
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: isRecording ? AppTheme.coralRed : AppTheme.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: (isRecording ? AppTheme.coralRed : AppTheme.primaryColor).withOpacity(0.3),
                            blurRadius: 16,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                        color: Colors.white,
                        size: 42,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Playback and comparison options when recording is available
                if (hasRecording) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Play child's recording
                      ElevatedButton.icon(
                        onPressed: () {
                          if (isPlayingRecorded) {
                            _recorderService.stopPlayback();
                          } else {
                            _recorderService.playRecording();
                          }
                        },
                        icon: Icon(
                          isPlayingRecorded ? Icons.stop_rounded : Icons.play_arrow_rounded,
                          size: 20,
                        ),
                        label: Text(
                          isPlayingRecorded ? 'إيقاف صوتي' : 'استمع لصوتك',
                          style: GoogleFonts.cairo(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.secondaryColor,
                          foregroundColor: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Compare with Sheikh
                      OutlinedButton.icon(
                        onPressed: () {
                          context.read<AudioPlayerService>().playAyahAtIndex(
                                widget.ayah.numberInSurah - 1,
                              );
                        },
                        icon: const Icon(Icons.volume_up_rounded, size: 20),
                        label: Text(
                          'استمع للشيخ',
                          style: GoogleFonts.cairo(fontSize: 14),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.primaryColor,
                          side: const BorderSide(color: AppTheme.primaryColor),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
              ],
            ),
          ),
        );
      },
    );
  }
}
