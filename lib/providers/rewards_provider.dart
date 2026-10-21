import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RewardsProvider extends ChangeNotifier {
  int _starsCount = 0;
  List<int> _memorizedSurahs = [];
  int _totalListenSessions = 0;

  int get starsCount => _starsCount;
  List<int> get memorizedSurahs => _memorizedSurahs;
  int get totalListenSessions => _totalListenSessions;

  RewardsProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _starsCount = prefs.getInt('stars_count') ?? 5; // Start with 5 welcome stars
    _totalListenSessions = prefs.getInt('listen_sessions') ?? 0;
    final memorizedStringList = prefs.getStringList('memorized_surahs') ?? [];
    _memorizedSurahs = memorizedStringList.map((e) => int.parse(e)).toList();
    notifyListeners();
  }

  Future<void> addStars(int count) async {
    _starsCount += count;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stars_count', _starsCount);
    notifyListeners();
  }

  Future<void> markSurahMemorized(int surahNumber) async {
    if (!_memorizedSurahs.contains(surahNumber)) {
      _memorizedSurahs.add(surahNumber);
      await addStars(10); // Reward 10 stars for completing a Surah!

      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        'memorized_surahs',
        _memorizedSurahs.map((e) => e.toString()).toList(),
      );
      notifyListeners();
    }
  }

  Future<void> incrementListenSession() async {
    _totalListenSessions++;
    if (_totalListenSessions % 3 == 0) {
      await addStars(2); // Star for every 3 listening sessions
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('listen_sessions', _totalListenSessions);
    notifyListeners();
  }

  bool isSurahMemorized(int surahNumber) {
    return _memorizedSurahs.contains(surahNumber);
  }
}
