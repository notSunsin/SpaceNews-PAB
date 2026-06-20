import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// A self-contained, copyright-safe vector illustration combining a
/// satellite and a newspaper to represent "space journalism" — used
/// on the Welcome Page in place of a hot-linked stock photo.
class SpaceJournalismIllustration extends StatelessWidget {
  final double size;

  const SpaceJournalismIllustration({super.key, this.size = 260});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Soft glow backdrop
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.accent.withOpacity(0.15),
            ),
          ),
          Container(
            width: size * 0.78,
            height: size * 0.78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withOpacity(0.06),
            ),
          ),
          // Orbit ring
          Container(
            width: size * 0.9,
            height: size * 0.9,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.18),
                width: 1.4,
              ),
            ),
          ),
          // Newspaper card (the "news" half of the story)
          Positioned(
            bottom: size * 0.12,
            child: Container(
              width: size * 0.5,
              height: size * 0.36,
              padding: EdgeInsets.all(size * 0.035),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: size * 0.22,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...List.generate(
                    3,
                    (i) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Container(
                        width: size * (0.4 - i * 0.06),
                        height: 4,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD7DAE6),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Satellite (the "space" half of the story)
          Positioned(
            top: size * 0.06,
            right: size * 0.08,
            child: Transform.rotate(
              angle: -0.35,
              child: Container(
                padding: EdgeInsets.all(size * 0.045),
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.satellite_alt_rounded,
                  color: AppColors.primary,
                  size: size * 0.16,
                ),
              ),
            ),
          ),
          // Small signal/broadcast dots travelling from satellite to news
          Positioned(
            top: size * 0.32,
            right: size * 0.28,
            child: Icon(Icons.circle, size: 6, color: AppColors.primary.withOpacity(0.4)),
          ),
          Positioned(
            top: size * 0.40,
            right: size * 0.36,
            child: Icon(Icons.circle, size: 5, color: AppColors.primary.withOpacity(0.3)),
          ),
        ],
      ),
    );
  }
}
