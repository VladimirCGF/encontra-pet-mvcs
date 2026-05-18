import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encontrapet/controller/pet_controller.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:encontrapet/view/widgets/custom_bottom_app_bar.dart';
import 'widgets/my_pet_card.dart';

class MyPetsScreen extends StatelessWidget {
  const MyPetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final petController = context.watch<PetController>();
    final pets = petController.myPets;
    final isLoading = petController.isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header Elegante
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meus Pets',
                    style: GoogleFonts.roboto(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Gerencie os pets que você cadastrou. Edite informações ou exclua registros que já foram encontrados!',
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Lista de Pets Gerenciáveis
            Expanded(
              child: isLoading && pets.isEmpty
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : pets.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.pets, size: 80, color: AppColors.textSecondary.withValues(alpha: 0.3)),
                              const SizedBox(height: 16),
                              Text(
                                'Você ainda não cadastrou nenhum pet.',
                                style: GoogleFonts.roboto(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Publique o primeiro clicando no botão + abaixo.',
                                style: GoogleFonts.roboto(color: AppColors.textSecondary, fontSize: 14),
                              ),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () async {
                            await context.read<PetController>().fetchAllPets();
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.all(20),
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: pets.length,
                            itemBuilder: (context, index) {
                              return MyPetCard(pet: pets[index]);
                            },
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomAppBar(currentIndex: 1), 
    );
  }
}
