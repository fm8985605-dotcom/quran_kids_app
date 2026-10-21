import 'package:flutter/foundation.dart';
import '../models/surah_model.dart';
import '../models/ayah_model.dart';
import '../models/reciter_model.dart';
import '../services/quran_api_service.dart';

class QuranProvider extends ChangeNotifier {
  final QuranApiService _apiService = QuranApiService();

  List<Surah> _allSurahs = [];
  List<Surah> _displayedSurahs = [];
  List<Ayah> _currentSurahAyahs = [];
  Surah? _selectedSurah;

  bool _isLoading = false;
  bool _isLoadingAyahs = false;
  String _searchQuery = '';
  bool _onlyJuzAmma = true; // Default to Juz Amma as it's the primary focus for kids

  Reciter _selectedReciter = Reciter.availableReciters.first;

  // Getters
  List<Surah> get surahs => _displayedSurahs;
  List<Ayah> get currentAyahs => _currentSurahAyahs;
  Surah? get selectedSurah => _selectedSurah;
  bool get isLoading => _isLoading;
  bool get isLoadingAyahs => _isLoadingAyahs;
  bool get onlyJuzAmma => _onlyJuzAmma;
  Reciter get selectedReciter => _selectedReciter;
  List<Reciter> get availableReciters => Reciter.availableReciters;

  QuranProvider() {
    loadSurahs();
  }

  Future<void> loadSurahs() async {
    _isLoading = true;
    notifyListeners();

    _allSurahs = await _apiService.getAllSurahs();
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectSurah(Surah surah) async {
    _selectedSurah = surah;
    _isLoadingAyahs = true;
    _currentSurahAyahs = [];
    notifyListeners();

    _currentSurahAyahs = await _apiService.getSurahAyahs(
      surah.number,
      _selectedReciter.folderIdentifier,
    );

    _isLoadingAyahs = false;
    notifyListeners();
  }

  void setReciter(Reciter reciter) {
    _selectedReciter = reciter;
    notifyListeners();

    // Reload current surah ayahs with new reciter audio if surah selected
    if (_selectedSurah != null) {
      selectSurah(_selectedSurah!);
    }
  }

  void toggleJuzAmmaFilter() {
    _onlyJuzAmma = !_onlyJuzAmma;
    _applyFilters();
    notifyListeners();
  }

  void searchSurah(String query) {
    _searchQuery = query.trim().toLowerCase();
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _displayedSurahs = _allSurahs.where((surah) {
      final matchesJuz = !_onlyJuzAmma || Surah.isJuzAmma(surah.number) || surah.number == 1; // Always include Al-Fatiha
      final matchesSearch = _searchQuery.isEmpty ||
          surah.name.contains(_searchQuery) ||
          surah.englishName.toLowerCase().contains(_searchQuery) ||
          surah.number.toString() == _searchQuery;

      return matchesJuz && matchesSearch;
    }).toList();
  }
}
