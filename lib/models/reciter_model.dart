class Reciter {
  final String id;
  final String nameArabic;
  final String descriptionArabic;
  final String folderIdentifier; // For everyayah.com
  final String subfolder;
  final bool isTeacherWithKids;

  const Reciter({
    required this.id,
    required this.nameArabic,
    required this.descriptionArabic,
    required this.folderIdentifier,
    this.subfolder = '',
    this.isTeacherWithKids = false,
  });

  static const List<Reciter> availableReciters = [
    Reciter(
      id: 'minshawi_teacher',
      nameArabic: 'الشيخ محمد صديق المنشاوي',
      descriptionArabic: 'المصحف المعلم مع ترديد الأطفال (أساسي للصغار)',
      folderIdentifier: 'Minshawy_Teacher_128kbps',
      isTeacherWithKids: true,
    ),
    Reciter(
      id: 'husary_teacher',
      nameArabic: 'الشيخ محمود خليل الحصري',
      descriptionArabic: 'المصحف المعلم مع ترديد الأطفال والوقف المناسب',
      folderIdentifier: 'Hussary_Teacher_128kbps',
      isTeacherWithKids: true,
    ),
    Reciter(
      id: 'khalefa_tunaiji',
      nameArabic: 'الشيخ خليفة الطنيجي',
      descriptionArabic: 'المصحف المعلم مع ترديد طفل بصوت هادئ',
      folderIdentifier: 'Tunaiji_64kbps',
      isTeacherWithKids: true,
    ),
  ];
}
