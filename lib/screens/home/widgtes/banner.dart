import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../utils/globals.dart';

class BannerHead extends StatelessWidget {
  const BannerHead({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: heightBanner,
      decoration: BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: [Colors.brown, Colors.orange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withValues(alpha: 0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Center(
        child: Text(
          'Matteo\'s WISHLIST',
          style: GoogleFonts.anton(
            fontSize: 40,
            color: const Color.fromARGB(255, 231, 199, 192),
            letterSpacing: 1.2,
            shadows: [
              Shadow(
                blurRadius: 6,
                color: Colors.brown.withValues(alpha: 0.3),
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
