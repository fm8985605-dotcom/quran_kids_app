class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;
  final int juzNumber;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
    required this.juzNumber,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['number'] ?? 0,
      name: json['name'] ?? '',
      englishName: json['englishName'] ?? '',
      englishNameTranslation: json['englishNameTranslation'] ?? '',
      numberOfAyahs: json['numberOfAyahs'] ?? 0,
      revelationType: json['revelationType'] ?? 'Meccan',
      juzNumber: json['juz'] ?? (json['number'] >= 78 ? 30 : 1),
    );
  }

  // Pre-configured list of Juz Amma surahs (الأجزاء الأكثر تحفيظاً للأطفال)
  static bool isJuzAmma(int surahNumber) {
    return surahNumber >= 78 && surahNumber <= 114;
  }
}
