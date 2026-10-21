import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/surah_model.dart';
import '../providers/quran_provider.dart';
import '../services/audio_player_service.dart';
import '../widgets/ayah_tile.dart';
import '../widgets/player_controls_bar.dart';
import 'recorder_dialog.dart';
import '../theme/app_theme.dart';

class SurahDetailScreen extends StatelessWidget {
  final Surah surah;

  const SurahDetailScreen({Key? key, required this.surah}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AudioPlayerService(),
      child: Consumer2<QuranProvider, AudioPlayerService>(
        builder: (context, quran, player, _) {
          if (quran.isLoadingAyahs) {
            return Scaffold(body: const Center(child: CircularProgressIndicator()));
          }

          // Initial load of the playlist
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (player.currentAyah == null && quran.currentAyahs.isNotEmpty) {
              player.loadPlaylist(quran.currentAyahs, autoPlay: false);
            }
          });

          return Scaffold(
            appBar: AppBar(
              title: Text(
                surah.name,
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                // Ayahs List
                Expanded(
                  child: ListView.builder(
                    itemCount: quran.currentAyahs.length,
                    itemBuilder: (context, index) {
                      final ayah = quran.currentAyahs[index];
                      final isPlaying = player.currentIndex == index && player.isPlaying;

                      return AyahTile(
                        ayah: ayah,
                        isPlaying: isPlaying,
                        currentRepeat: player.currentAyahPlayTimes,
                        targetRepeat: player.repeatCountPerAyah,
                        onPlayTap: () {
                          if (isPlaying) {
                            player.pause();
                          } else {
                            player.playAyahAtIndex(index);
                          }
                        },
                        onRecordTap: () => RecorderDialog.show(context, ayah),
                      );
                    },
                  ),
                ),
                // Persistent Player Controls at bottom
                PlayerControlsBar(
                  playerService: player,
                  onNext: () => player.nextAyah(),
                  onPrevious: () => player.previousAyah(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
