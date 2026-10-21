import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/quran_provider.dart';
import '../providers/rewards_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/star_rating_badge.dart';
import 'surah_detail_screen.dart';
import '../models/reciter_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quranProvider = context.watch<QuranProvider>();
    final rewardsProvider = context.watch<RewardsProvider>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Friendly Header App Bar
          SliverAppBar(
            expandedHeight: 220.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryColor, AppTheme.accentColor],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.menu_book_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'المصحف المعلم للصغار',
                                  style: GoogleFonts.cairo(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const StarRatingBadge(),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Quick encouraging quote
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.favorite_rounded, color: AppTheme.coralRed, size: 22),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'استمع وردد الآيات مع الشيخ لتكون حافظاً صغيراً للقرآن الكريم! ⭐',
                                  style: GoogleFonts.cairo(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  children: [
                    // Search bar
                    Expanded(
                      child: TextField(
                        onChanged: (val) => quranProvider.searchSurah(val),
                        decoration: InputDecoration(
                          hintText: 'ابحث عن اسم السورة أو رقمها...',
                          hintStyle: GoogleFonts.cairo(fontSize: 14, color: Colors.grey),
                          prefixIcon: const Icon(Icons.search_rounded, color: AppTheme.primaryColor),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Juz Amma Toggle Filter Button
                    ElevatedButton.icon(
                      onPressed: () => quranProvider.toggleJuzAmmaFilter(),
                      icon: Icon(
                        quranProvider.onlyJuzAmma ? Icons.star : Icons.all_inclusive,
                        size: 18,
                      ),
                      label: Text(
                        quranProvider.onlyJuzAmma ? 'جزء عمّ' : 'الكل',
                        style: GoogleFonts.cairo(fontSize: 14),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: quranProvider.onlyJuzAmma ? AppTheme.secondaryColor : Colors.white,
                        foregroundColor: quranProvider.onlyJuzAmma ? Colors.black87 : AppTheme.primaryColor,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Reciter Selection Banner
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: () => _showReciterPicker(context, quranProvider),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.record_voice_over_rounded, color: AppTheme.primaryColor),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'القارئ الحالي (المصحف المعلم):',
                              style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
                            ),
                            Text(
                              quranProvider.selectedReciter.nameArabic,
                              style: GoogleFonts.cairo(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Surahs List Grid / List
          quranProvider.isLoading
              ? const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              : quranProvider.surahs.isEmpty
                  ? SliverFillRemaining(
                      child: Center(
                        child: Text(
                          'لا توجد سور مطابقة للبحث',
                          style: GoogleFonts.cairo(fontSize: 18, color: Colors.grey),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final surah = quranProvider.surahs[index];
                            final isMemorized = rewardsProvider.isSurahMemorized(surah.number);

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.04),
                                    blurRadius: 6,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                leading: Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: isMemorized ? AppTheme.mintGreen.withOpacity(0.2) : AppTheme.primaryColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: isMemorized
                                        ? const Icon(Icons.check_rounded, color: AppTheme.mintGreen, size: 26)
                                        : Text(
                                            '${surah.number}',
                                            style: GoogleFonts.cairo(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.primaryColor,
                                            ),
                                          ),
                                  ),
                                ),
                                title: Text(
                                  surah.name,
                                  style: GoogleFonts.cairo(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2D3436),
                                  ),
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      'عدد الآيات: ${surah.numberOfAyahs}',
                                      style: GoogleFonts.cairo(fontSize: 13, color: Colors.grey),
                                    ),
                                    const SizedBox(width: 10),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: surah.revelationType == 'Meccan' ? Colors.amber.withOpacity(0.2) : Colors.blue.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        surah.revelationType == 'Meccan' ? 'مكية' : 'مدنية',
                                        style: GoogleFonts.cairo(
                                          fontSize: 11,
                                          color: surah.revelationType == 'Meccan' ? Colors.amber[800] : Colors.blue[800],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (isMemorized)
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8.0),
                                        child: Icon(Icons.star_rounded, color: AppTheme.secondaryColor, size: 24),
                                      ),
                                    const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                                  ],
                                ),
                                onTap: () {
                                  quranProvider.selectSurah(surah);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SurahDetailScreen(surah: surah),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                          childCount: quranProvider.surahs.length,
                        ),
                      ),
                    ),
          const SliverToBoxAdapter(child: SizedBox(height: 30)),
        ],
      ),
    );
  }

  void _showReciterPicker(BuildContext context, QuranProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'اختر القارئ والمعلم المفضّل:',
                style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...provider.availableReciters.map((reciter) {
                final isSelected = provider.selectedReciter.id == reciter.id;
                return ListTile(
                  leading: Icon(
                    Icons.record_voice_over_rounded,
                    color: isSelected ? AppTheme.primaryColor : Colors.grey,
                  ),
                  title: Text(
                    reciter.nameArabic,
                    style: GoogleFonts.cairo(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppTheme.primaryColor : Colors.black87,
                    ),
                  ),
                  subtitle: Text(
                    reciter.descriptionArabic,
                    style: GoogleFonts.cairo(fontSize: 12),
                  ),
                  trailing: isSelected ? const Icon(Icons.check_circle, color: AppTheme.primaryColor) : null,
                  onTap: () {
                    provider.setReciter(reciter);
                    Navigator.pop(context);
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }
}
