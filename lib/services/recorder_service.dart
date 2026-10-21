import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';

enum RecordingStatus { idle, recording, recorded, playingRecorded }

class RecorderService extends ChangeNotifier {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _playbackPlayer = AudioPlayer();

  RecordingStatus _status = RecordingStatus.idle;
  String? _recordedFilePath;

  RecordingStatus get status => _status;
  bool get isRecording => _status == RecordingStatus.recording;
  bool get hasRecording => _recordedFilePath != null && File(_recordedFilePath!).existsSync();
  bool get isPlayingRecorded => _status == RecordingStatus.playingRecorded;
  String? get recordedFilePath => _recordedFilePath;

  RecorderService() {
    _playbackPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _status = RecordingStatus.recorded;
        notifyListeners();
      }
    });
  }

  // Start recording the child's recitation
  Future<bool> startRecording(int surahNum, int ayahNum) async {
    try {
      if (await _recorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/recitation_${surahNum}_$ayahNum.m4a';

        await _recorder.start(
          const RecordConfig(encoder: AudioEncoder.aacLc),
          path: path,
        );

        _recordedFilePath = path;
        _status = RecordingStatus.recording;
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error starting recording: $e');
      _status = RecordingStatus.idle;
      notifyListeners();
      return false;
    }
  }

  // Stop recording
  Future<String?> stopRecording() async {
    try {
      final path = await _recorder.stop();
      _recordedFilePath = path;
      _status = RecordingStatus.recorded;
      notifyListeners();
      return path;
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      _status = RecordingStatus.idle;
      notifyListeners();
      return null;
    }
  }

  // Play back the child's recorded voice
  Future<void> playRecording() async {
    if (_recordedFilePath == null) return;

    try {
      _status = RecordingStatus.playingRecorded;
      notifyListeners();

      await _playbackPlayer.setFilePath(_recordedFilePath!);
      await _playbackPlayer.play();
    } catch (e) {
      debugPrint('Error playing recording: $e');
      _status = RecordingStatus.recorded;
      notifyListeners();
    }
  }

  // Stop playing recording
  Future<void> stopPlayback() async {
    await _playbackPlayer.stop();
    _status = RecordingStatus.recorded;
    notifyListeners();
  }

  // Delete recording
  void clearRecording() {
    if (_recordedFilePath != null) {
      final file = File(_recordedFilePath!);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    _recordedFilePath = null;
    _status = RecordingStatus.idle;
    notifyListeners();
  }

  @override
  void dispose() {
    _recorder.dispose();
    _playbackPlayer.dispose();
    super.dispose();
  }
}
