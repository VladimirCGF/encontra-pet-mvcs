import 'package:flutter/material.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Buscar por nome, raça ou local',
            hintStyle: GoogleFonts.roboto(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
              size: 22,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          ),
          style: GoogleFonts.roboto(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
