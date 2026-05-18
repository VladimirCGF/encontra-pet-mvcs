import 'package:encontrapet/view/widgets/custom_bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encontrapet/controller/pet_controller.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/home_categories.dart';
import 'widgets/pet_list_section.dart';
import 'widgets/pet_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Agenda o carregamento dos pets para rodar logo após a renderização do primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<PetController>().fetchAllPets();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final petController = context.watch<PetController>();
    final pets = petController.feedPets;
    final isLoading = petController.isLoading;
    final hasActiveFilter = petController.searchQuery.isNotEmpty || petController.selectedCategory != 'Todos';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {
            await context.read<PetController>().fetchAllPets();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(), // Garante que o Pull to Refresh funcione mesmo com lista vazia
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Header
                const HomeHeader(),
                
                // 2. Search Bar (conectado ao Controller)
                HomeSearchBar(
                  onChanged: (query) {
                    context.read<PetController>().searchQuery = query;
                  },
                ),
                const SizedBox(height: 12),
                
                // 3. Categories (conectado ao Controller)
                HomeCategories(
                  onCategorySelected: (category) {
                    context.read<PetController>().selectedCategory = category;
                  },
                ),
                
                // 4. Pet List Title Section
                const PetListSection(),
                
                // 5. Vertical list of Pet Cards
                if (isLoading && pets.isEmpty) // Apenas mostra loading em tela cheia na primeira carga
                  const Padding(
                    padding: EdgeInsets.all(64.0),
                    child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                  )
                else if (pets.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(48.0),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            hasActiveFilter ? Icons.search_off : Icons.pets,
                            size: 64,
                            color: AppColors.textSecondary.withValues(alpha: 0.3),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            hasActiveFilter
                                ? 'Nenhum pet encontrado para esta busca.'
                                : 'Nenhum pet cadastrado ainda.',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: pets.length,
                    itemBuilder: (context, index) {
                      final pet = pets[index];
                      return PetCard(pet: pet,
                      );
                    },
                  ),
                const SizedBox(height: 40), // Espaço extra para scroll do FAB/BottomBar
              ],
            ),
          ),
        ),
      ),
      // Custom BottomAppBar matching layout
      bottomNavigationBar: const CustomBottomAppBar(currentIndex: 0),
    );
  }
}

