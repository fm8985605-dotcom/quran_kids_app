import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import '../models/ayah_model.dart';

enum PlayerStatus { stopped, playing, paused, loading, error }

class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();

  List<Ayah> _currentPlaylist = [];
  int _currentIndex = 0;
  PlayerStatus _status = PlayerStatus.stopped;

  // Repetition logic for Kids Quran Memorization
  int _repeatCountPerAyah = 2; // Default 2 times repeat for learning
  int _currentAyahPlayTimes = 0;
  bool _repeatEntireSurah = false;

  // Getters
  PlayerStatus get status => _status;
  bool get isPlaying => _status == PlayerStatus.playing;
  bool get isLoading => _status == PlayerStatus.loading;
  int get currentIndex => _currentIndex;
  Ayah? get currentAyah => _currentPlaylist.isNotEmpty && _currentIndex < _currentPlaylist.length ? _currentPlaylist[_currentIndex] : null;
  int get repeatCountPerAyah => _repeatCountPerAyah;
  int get currentAyahPlayTimes => _currentAyahPlayTimes;
  bool get repeatEntireSurah => _repeatEntireSurah;
  Duration get position => _player.position;
  Duration get duration => _player.duration ?? Duration.zero;

  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;

  AudioPlayerService() {
    _initPlayerListeners();
  }

  void _initPlayerListeners() {
    _player.playerStateStream.listen((playerState) {
      if (playerState.processingState == ProcessingState.completed) {
        _onAyahFinished();
      } else if (playerState.processingState == ProcessingState.loading ||
          playerState.processingState == ProcessingState.buffering) {
        _status = PlayerStatus.loading;
        notifyListeners();
      } else if (playerState.playing) {
        _status = PlayerStatus.playing;
        notifyListeners();
      } else {
        _status = PlayerStatus.paused;
        notifyListeners();
      }
    });
  }

  void setRepeatCount(int count) {
    _repeatCountPerAyah = count;
    notifyListeners();
  }

  void toggleRepeatEntireSurah() {
    _repeatEntireSurah = !_repeatEntireSurah;
    notifyListeners();
  }

  // Load a surah playlist and optionally start playing
  Future<void> loadPlaylist(List<Ayah> ayahs, {int startIndex = 0, bool autoPlay = true}) async {
    _currentPlaylist = ayahs;
    _currentIndex = startIndex;
    _currentAyahPlayTimes = 0;

    if (autoPlay && ayahs.isNotEmpty) {
      await playAyahAtIndex(startIndex);
    }
  }

  // Play a specific Ayah in the playlist
  Future<void> playAyahAtIndex(int index) async {
    if (index < 0 || index >= _currentPlaylist.length) return;

    _currentIndex = index;
    _currentAyahPlayTimes = 0;
    final ayah = _currentPlaylist[index];

    try {
      _status = PlayerStatus.loading;
      notifyListeners();

      await _player.setUrl(ayah.audioUrl);
      await _player.play();
      _status = PlayerStatus.playing;
      notifyListeners();
    } catch (e) {
      debugPrint('Error playing audio: $e');
      _status = PlayerStatus.error;
      notifyListeners();
    }
  }

  // Called automatically when an Ayah finishes playing
  void _onAyahFinished() {
    _currentAyahPlayTimes++;

    // Check if we need to repeat the current Ayah
    if (_currentAyahPlayTimes < _repeatCountPerAyah) {
      // Replay the same Ayah for memorization
      _player.seek(Duration.zero);
      _player.play();
      notifyListeners();
      return;
    }

    // Move to next Ayah
    if (_currentIndex + 1 < _currentPlaylist.length) {
      _currentIndex++;
      _currentAyahPlayTimes = 0;
      playAyahAtIndex(_currentIndex);
    } else {
      // Reached end of Surah
      if (_repeatEntireSurah) {
        _currentIndex = 0;
        _currentAyahPlayTimes = 0;
        playAyahAtIndex(0);
      } else {
        _status = PlayerStatus.stopped;
        notifyListeners();
      }
    }
  }

  Future<void> pause() async {
    await _player.pause();
    _status = PlayerStatus.paused;
    notifyListeners();
  }

  Future<void> resume() async {
    await _player.play();
    _status = PlayerStatus.playing;
    notifyListeners();
  }

  Future<void> stop() async {
    await _player.stop();
    _status = PlayerStatus.stopped;
    notifyListeners();
  }

  Future<void> nextAyah() async {
    if (_currentIndex + 1 < _currentPlaylist.length) {
      await playAyahAtIndex(_currentIndex + 1);
    }
  }

  Future<void> previousAyah() async {
    if (_currentIndex > 0) {
      await playAyahAtIndex(_currentIndex - 1);
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
