import 'package:encontrapet/view/home/home_screen.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../my_pets/my_pets_screen.dart';
import '../profile/profile_screen.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int currentIndex; // Para você saber qual aba está ativa

  const CustomBottomAppBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          // Home Tab
          IconButton(
            icon: Icon(
              currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
            ),
            color: currentIndex == 0 ? AppColors.primary : Colors.grey[400],
            iconSize: 28,
            onPressed: () {
              if (currentIndex != 0) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              }
            },
          ),

          // Pets Tab
          IconButton(
            icon: const Icon(Icons.pets_rounded),
            color: currentIndex == 1 ? AppColors.primary : Colors.grey[400],
            iconSize: 28,
            onPressed: () {
              if (currentIndex != 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MyPetsScreen()),
                );
              }
            },
          ),

          // Profile Tab
          IconButton(
            icon: Icon(
              currentIndex == 2
                  ? Icons.person_rounded
                  : Icons.person_outline_rounded,
            ),
            color: currentIndex == 2 ? AppColors.primary : Colors.grey[400],
            iconSize: 28,
            onPressed: () {
              if (currentIndex != 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
