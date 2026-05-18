import 'package:flutter/material.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class DisappearanceSection extends StatelessWidget {
  final String? initialDate;
  final String? initialDescription;

  const DisappearanceSection({
    super.key,
    this.initialDate,
    this.initialDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, color: Color(0xFF00B4FF), size: 22),
              const SizedBox(width: 8),
              Text(
                'Desaparecimento',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Data
          _buildLabel('Data'),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: initialDate,
            style: GoogleFonts.roboto(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'mm/dd/yyyy',
              hintStyle: GoogleFonts.roboto(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              suffixIcon: const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00B4FF), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Descrição
          _buildLabel('Descrição'),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: initialDescription,
            maxLines: 4,
            style: GoogleFonts.roboto(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Como o pet é, comportamento, marcas...',
              hintStyle: GoogleFonts.roboto(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.all(16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00B4FF), width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.roboto(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }
}
