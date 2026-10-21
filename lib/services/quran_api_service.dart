import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/surah_model.dart';
import '../models/ayah_model.dart';

class QuranApiService {
  static const String baseUrl = 'https://api.alquran.cloud/v1';

  // Fetch all 114 Surahs
  Future<List<Surah>> getAllSurahs() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surah'));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final List list = data['data'];
        return list.map((item) => Surah.fromJson(item)).toList();
      }
    } catch (e) {
      // In case of network error, return offline essential list
    }
    return _getFallbackSurahs();
  }

  // Fetch Ayahs for a given Surah
  Future<List<Ayah>> getSurahAyahs(int surahNumber, String reciterIdentifier) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/surah/$surahNumber/quran-uthmani'));
      if (response.statusCode == 200) {
        final data = json.decode(utf8.decode(response.bodyBytes));
        final List ayahsList = data['data']['ayahs'];
        return ayahsList.map((item) => Ayah.fromJson(item, surahNumber, reciterIdentifier)).toList();
      }
    } catch (e) {
      // Offline fallback
    }
    return _getFallbackAyahs(surahNumber, reciterIdentifier);
  }

  // Generate direct streaming URL for an Ayah
  String getAyahAudioUrl(int surahNumber, int ayahNumberInSurah, String reciterFolder) {
    final s = surahNumber.toString().padLeft(3, '0');
    final a = ayahNumberInSurah.toString().padLeft(3, '0');
    return 'https://everyayah.com/data/$reciterFolder/$s$a.mp3';
  }

  // Fallback offline Surahs (Particularly short Surahs from Juz Amma)
  List<Surah> _getFallbackSurahs() {
    return [
      Surah(number: 1, name: 'سُورَةُ ٱلْفَاتِحَةِ', englishName: 'Al-Faatiha', englishNameTranslation: 'The Opening', numberOfAyahs: 7, revelationType: 'Meccan', juzNumber: 1),
      Surah(number: 112, name: 'سُورَةُ الإِخْلَاصِ', englishName: 'Al-Ikhlaas', englishNameTranslation: 'Sincerity', numberOfAyahs: 4, revelationType: 'Meccan', juzNumber: 30),
      Surah(number: 113, name: 'سُورَةُ الفَلَقِ', englishName: 'Al-Falaq', englishNameTranslation: 'The Daybreak', numberOfAyahs: 5, revelationType: 'Meccan', juzNumber: 30),
      Surah(number: 114, name: 'سُورَةُ النَّاسِ', englishName: 'An-Naas', englishNameTranslation: 'Mankind', numberOfAyahs: 6, revelationType: 'Meccan', juzNumber: 30),
      Surah(number: 108, name: 'سُورَةُ الكَوْثَرِ', englishName: 'Al-Kawthar', englishNameTranslation: 'Abundance', numberOfAyahs: 3, revelationType: 'Meccan', juzNumber: 30),
      Surah(number: 110, name: 'سُورَةُ النَّصْرِ', englishName: 'An-Nasr', englishNameTranslation: 'Divine Support', numberOfAyahs: 3, revelationType: 'Medinan', juzNumber: 30),
    ];
  }

  List<Ayah> _getFallbackAyahs(int surahNumber, String reciterIdentifier) {
    if (surahNumber == 1) {
      return [
        Ayah(number: 1, numberInSurah: 1, surahNumber: 1, text: 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ', audioUrl: getAyahAudioUrl(1, 1, reciterIdentifier), juz: 1, page: 1),
        Ayah(number: 2, numberInSurah: 2, surahNumber: 1, text: 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ', audioUrl: getAyahAudioUrl(1, 2, reciterIdentifier), juz: 1, page: 1),
        Ayah(number: 3, numberInSurah: 3, surahNumber: 1, text: 'ٱلرَّحْمَٰنِ ٱلرَّحِيمِ', audioUrl: getAyahAudioUrl(1, 3, reciterIdentifier), juz: 1, page: 1),
        Ayah(number: 4, numberInSurah: 4, surahNumber: 1, text: 'مَٰلِكِ يَوْمِ ٱلدِّينِ', audioUrl: getAyahAudioUrl(1, 4, reciterIdentifier), juz: 1, page: 1),
        Ayah(number: 5, numberInSurah: 5, surahNumber: 1, text: 'إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ', audioUrl: getAyahAudioUrl(1, 5, reciterIdentifier), juz: 1, page: 1),
        Ayah(number: 6, numberInSurah: 6, surahNumber: 1, text: 'ٱهْدِنَا ٱلصِّرَٰطَ ٱلْمُسْتَقِيمَ', audioUrl: getAyahAudioUrl(1, 6, reciterIdentifier), juz: 1, page: 1),
        Ayah(number: 7, numberInSurah: 7, surahNumber: 1, text: 'صِرَٰطَ ٱلَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ ٱلْمَغْضُوبِ عَلَيْهِمْ وَلَا ٱلضَّآلِّينَ', audioUrl: getAyahAudioUrl(1, 7, reciterIdentifier), juz: 1, page: 1),
      ];
    } else if (surahNumber == 112) {
      return [
        Ayah(number: 6222, numberInSurah: 1, surahNumber: 112, text: 'قُلْ هُوَ ٱللَّهُ أَحَدٌ', audioUrl: getAyahAudioUrl(112, 1, reciterIdentifier), juz: 30, page: 604),
        Ayah(number: 6223, numberInSurah: 2, surahNumber: 112, text: 'ٱللَّهُ ٱلصَّمَدُ', audioUrl: getAyahAudioUrl(112, 2, reciterIdentifier), juz: 30, page: 604),
        Ayah(number: 6224, numberInSurah: 3, surahNumber: 112, text: 'لَمْ يَلِدْ وَلَمْ يُولَدْ', audioUrl: getAyahAudioUrl(112, 3, reciterIdentifier), juz: 30, page: 604),
        Ayah(number: 6225, numberInSurah: 4, surahNumber: 112, text: 'وَلَمْ يَكُن لَّهُۥ كُفُوًا أَحَدٌ', audioUrl: getAyahAudioUrl(112, 4, reciterIdentifier), juz: 30, page: 604),
      ];
    }
    return [];
  }
}
