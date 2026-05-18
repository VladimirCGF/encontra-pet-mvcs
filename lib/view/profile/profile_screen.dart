import 'package:flutter/material.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:encontrapet/view/auth/login_page.dart';
import 'package:encontrapet/view/profile/edit_profile_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_bottom_app_bar.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_menu_item.dart';
import 'widgets/logout_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Stack: Header + Overlapping Stats Card
              Stack(
                clipBehavior: Clip.none,
                children: const [
                  ProfileHeader(),
                ],
              ),
              const SizedBox(height: 48), // Padding after the overlap
              
              // 2. CONTA Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
                child: Text(
                  'CONTA',
                  style: GoogleFonts.roboto(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: Icons.person_outline_rounded,
                      title: 'Editar perfil',
                      subtitle: 'Nome, contato',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                        );
                      },
                    ),
                    ProfileMenuItem(
                      icon: Icons.lock_outline_rounded,
                      title: 'Alterar senha',
                      subtitle: 'Segurança da conta',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Logout Option Button
              LogoutButton(
                onTap: () {
                  // Voltar para a página de Login reiniciando a stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),

      
      // 6. Custom BottomAppBar notched navigation
        bottomNavigationBar: const CustomBottomAppBar(currentIndex: 2),
    );
  }
}
