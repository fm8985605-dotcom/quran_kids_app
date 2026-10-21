class Ayah {
  final int number; // Global Ayah number (1 - 6236)
  final int numberInSurah;
  final int surahNumber;
  final String text;
  final String audioUrl;
  final int juz;
  final int page;

  Ayah({
    required this.number,
    required this.numberInSurah,
    required this.surahNumber,
    required this.text,
    required this.audioUrl,
    required this.juz,
    required this.page,
  });

  factory Ayah.fromJson(Map<String, dynamic> json, int surahNum, String reciterIdentifier) {
    final ayahGlobalNum = json['number'] ?? 0;
    final inSurah = json['numberInSurah'] ?? 0;

    // Construct audio URL from EveryAyah format if direct audio isn't provided:
    // Format: https://everyayah.com/data/Minshawy_Teacher_128kbps/001001.mp3
    final surahPadded = surahNum.toString().padLeft(3, '0');
    final ayahPadded = inSurah.toString().padLeft(3, '0');
    final fallbackAudio = 'https://everyayah.com/data/$reciterIdentifier/$surahPadded$ayahPadded.mp3';

    return Ayah(
      number: ayahGlobalNum,
      numberInSurah: inSurah,
      surahNumber: surahNum,
      text: json['text'] ?? '',
      audioUrl: json['audio'] ?? fallbackAudio,
      juz: json['juz'] ?? 30,
      page: json['page'] ?? 1,
    );
  }
}
