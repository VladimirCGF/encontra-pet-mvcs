import 'package:flutter/material.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class BasicInfoSection extends StatefulWidget {
  final String? initialName;
  final String? initialType;
  final String? initialBreed;
  final String? initialColor;
  final String? initialAge;

  const BasicInfoSection({
    super.key,
    this.initialName,
    this.initialType,
    this.initialBreed,
    this.initialColor,
    this.initialAge,
  });

  @override
  State<BasicInfoSection> createState() => _BasicInfoSectionState();
}

class _BasicInfoSectionState extends State<BasicInfoSection> {
  int _selectedType = 0;
  final List<String> _types = ['Cachorro', 'Gato', 'Outro'];

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null) {
      _selectedType = _types.indexOf(widget.initialType!);
      if (_selectedType < 0) _selectedType = 0;
    }
  }

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
            initialValue: widget.initialName,
          ),
          const SizedBox(height: 16),

          // Tipo (Chips)
          _buildLabel('Tipo'),
          const SizedBox(height: 8),
          Row(
            children: List.generate(_types.length, (index) {
              final isSelected = _selectedType == index;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedType = index),
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
                      _types[index],
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
              );
            }),
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
                    _buildTextField(placeholder: 'SRD', initialValue: widget.initialBreed),
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
                    _buildTextField(placeholder: 'Caramelo', initialValue: widget.initialColor),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Idade
          _buildLabel('Idade aproximada'),
          const SizedBox(height: 6),
          _buildTextField(placeholder: '3 anos', initialValue: widget.initialAge),
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

  Widget _buildTextField({required String placeholder, String? initialValue}) {
    return TextFormField(
      initialValue: initialValue,
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
