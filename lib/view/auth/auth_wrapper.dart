import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encontrapet/controller/auth_controller.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:encontrapet/view/auth/login_page.dart';
import 'package:encontrapet/view/main_shell.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    // Agenda a verificação silenciosa de sessão logo após a renderização do primeiro frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkSession();
    });
  }

  Future<void> _checkSession() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    
    // Tenta carregar a sessão persistente (1.0 a 1.5s de atraso para visualização da splash premium)
    await Future.delayed(const Duration(milliseconds: 1200));
    final hasActiveSession = await authController.loadSession();

    if (!mounted) return;

    if (hasActiveSession) {
      // Redireciona para a Home limpando a pilha de telas
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainShell()),
      );
    } else {
      // Redireciona para o Login limpando a pilha de telas
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo com efeito de pulso / marca premium
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.pets_rounded,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'EncontraPET',
              style: GoogleFonts.roboto(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Buscando sua sessão...',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 40),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
