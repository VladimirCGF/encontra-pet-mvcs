import 'package:flutter/material.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../new_pet/widgets/basic_info_section.dart';
import '../new_pet/widgets/disappearance_section.dart';
import '../new_pet/widgets/location_section.dart';
import '../new_pet/widgets/photos_section.dart';

class EditPetScreen extends StatelessWidget {
  final String name;
  final String type;
  final String breed;
  final String color;
  final String age;
  final String location;
  final String date;
  final String description;

  const EditPetScreen({
    super.key,
    required this.name,
    required this.type,
    required this.breed,
    required this.color,
    required this.age,
    required this.location,
    required this.date,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Editar pet',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Atualize as informações do pet.',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable form — pre-filled with pet data
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    BasicInfoSection(
                      initialName: name,
                      initialType: type,
                      initialBreed: breed,
                      initialColor: color,
                      initialAge: age,
                    ),
                    const SizedBox(height: 16),
                    DisappearanceSection(
                      initialDate: date,
                      initialDescription: description,
                    ),
                    const SizedBox(height: 16),
                    LocationSection(initialLocation: location),
                    const SizedBox(height: 16),
                    const PhotosSection(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Save button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Salvar alterações',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
