import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encontrapet/controller/pet_controller.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/custom_bottom_app_bar.dart';
import 'widgets/my_pet_card.dart';

class MyPetsScreen extends StatelessWidget {
  const MyPetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final petController = context.watch<PetController>();
    final myPets = petController.myPets;
    final isLoading = petController.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SUA BIBLIOTECA',
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFF97316),
                      letterSpacing: 1.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Meus Pets',
                    style: GoogleFonts.roboto(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Você tem ${myPets.length} pets cadastrados.',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Pet list
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : myPets.isEmpty
                      ? const Center(child: Text('Nenhum pet cadastrado.'))
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                          itemCount: myPets.length,
                          itemBuilder: (context, index) {
                            final pet = myPets[index];
                            return MyPetCard(
                              name: pet.name,
                              breed: pet.breed,
                              age: pet.date,
                              location: pet.location,
                              imageUrl: pet.imageUrl,
                              isLost: pet.isLost,
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      // BottomAppBar — "Meus Pets" tab active
      bottomNavigationBar: const CustomBottomAppBar(currentIndex: 1),
    );
  }
}
