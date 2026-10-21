import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/rewards_provider.dart';
import '../theme/app_theme.dart';

class StarRatingBadge extends StatelessWidget {
  final VoidCallback? onTap;

  const StarRatingBadge({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stars = context.watch<RewardsProvider>().starsCount;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.star_rounded,
              color: AppTheme.secondaryColor,
              size: 26,
            ),
            const SizedBox(width: 6),
            Text(
              '$stars',
              style: GoogleFonts.cairo(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3436),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
