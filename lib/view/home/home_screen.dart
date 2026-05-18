import 'package:encontrapet/view/widgets/custom_bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encontrapet/controller/pet_controller.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/home_categories.dart';
import 'widgets/pet_list_section.dart';
import 'widgets/pet_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mockPets = context.watch<PetController>().feedPets;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header
              const HomeHeader(),
              
              // 2. Search Bar
              const HomeSearchBar(),
              const SizedBox(height: 12),
              
              // 3. Categories (Horizontal scrollable chips)
              const HomeCategories(),
              
              // 4. Pet List Title Section
              const PetListSection(),
              
              // 5. Vertical list of Pet Cards
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: mockPets.length,
                itemBuilder: (context, index) {
                  final pet = mockPets[index];
                  return PetCard(
                    name: pet.name,
                    breed: pet.breed,
                    imageUrl: pet.imageUrl,
                    location: pet.location,
                    date: pet.date,
                    isLost: pet.isLost,
                  );
                },
              ),
              const SizedBox(height: 40), // Espaço extra para scroll do FAB/BottomBar
            ],
          ),
        ),
      ),
      // Custom BottomAppBar matching layout
      bottomNavigationBar: const CustomBottomAppBar(currentIndex: 0),
    );
  }
}
