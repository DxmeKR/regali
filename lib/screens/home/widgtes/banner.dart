import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// UTILS
import '../../../utils/globals.dart';

class BannerHead extends StatelessWidget {
  const BannerHead({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heightBanner,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(8),
          bottomRight: Radius.circular(8),
        ),
        gradient: const LinearGradient(
          colors: [
            Color(0xFFD98CA5), // Rosa antico pastello
            Color(0xFFC58BA8), // Malva pastello
            Color(0xFFB783A5), // Lilla rosato
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFB783A5).withValues(alpha: 0.4),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          titleBanner,
          textAlign: TextAlign.center,
          style: GoogleFonts.anton(
            fontSize: 40,
            color: const Color(0xFFFFF0F4), // Rosa molto chiaro
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                blurRadius: 5,
                color: const Color(0xFF713B59).withValues(alpha: 0.4),
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
