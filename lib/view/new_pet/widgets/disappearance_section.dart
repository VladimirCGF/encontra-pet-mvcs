import 'package:flutter/material.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class DisappearanceSection extends StatelessWidget {
  final TextEditingController dateController;
  final TextEditingController descriptionController;

  const DisappearanceSection({
    super.key,
    required this.dateController,
    required this.descriptionController,
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
            controller: dateController,
            readOnly: true,
            onTap: () async {
              final DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      colorScheme: const ColorScheme.light(
                        primary: Color(0xFF00B4FF), 
                        onPrimary: Colors.white,
                        onSurface: Colors.black, 
                      ),
                    ),
                    child: child!,
                  );
                },
              );

              if (pickedDate != null) {
                final day = pickedDate.day.toString().padLeft(2, '0');
                final month = pickedDate.month.toString().padLeft(2, '0');
                final year = pickedDate.year.toString();
                dateController.text = '$day/$month/$year';
              }
            },
            style: GoogleFonts.roboto(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'dd/mm/aaaa',
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
            controller: descriptionController,
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
