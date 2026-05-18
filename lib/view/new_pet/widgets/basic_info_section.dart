import 'package:flutter/material.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicInfoSection extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController breedController;
  final TextEditingController colorController;
  final TextEditingController ageController;
  final String selectedType;
  final ValueChanged<String> onTypeChanged;

  const BasicInfoSection({
    super.key,
    required this.nameController,
    required this.breedController,
    required this.colorController,
    required this.ageController,
    required this.selectedType,
    required this.onTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> types = ['Cachorro', 'Gato', 'Outro'];

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
              const Icon(Icons.pets_outlined, color: Color(0xFF00B4FF), size: 22),
              const SizedBox(width: 8),
              Text(
                'Informações básicas',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Nome do pet
          _buildLabel('Nome do pet'),
          const SizedBox(height: 6),
          _buildTextField(
            placeholder: 'Ex: Thor',
            controller: nameController,
          ),
          const SizedBox(height: 16),

          // Tipo (Chips)
          _buildLabel('Tipo'),
          const SizedBox(height: 8),
          Row(
            children: types.map((type) {
              final isSelected = selectedType == type;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => onTypeChanged(type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.border,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      type,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // Raça e Cor (side by side)
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Raça'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      placeholder: 'SRD',
                      controller: breedController,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel('Cor'),
                    const SizedBox(height: 6),
                    _buildTextField(
                      placeholder: 'Caramelo',
                      controller: colorController,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Idade
          _buildLabel('Idade aproximada'),
          const SizedBox(height: 6),
          _buildTextField(
            placeholder: '3 anos',
            controller: ageController,
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

  Widget _buildTextField({required String placeholder, required TextEditingController controller}) {
    return TextFormField(
      controller: controller,
      style: GoogleFonts.roboto(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        hintText: placeholder,
        hintStyle: GoogleFonts.roboto(color: Colors.grey[400], fontSize: 14),
        filled: true,
        fillColor: AppColors.background,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF00B4FF), width: 1.5),
        ),
      ),
    );
  }
}
