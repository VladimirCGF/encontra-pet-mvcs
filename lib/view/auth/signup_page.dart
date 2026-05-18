import 'package:flutter/material.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:encontrapet/view/widgets/custom_button.dart';
import 'package:encontrapet/view/widgets/custom_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Criar Conta',
                style: GoogleFonts.roboto(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cadastre-se para começar a ajudar pets perdidos',
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 40),
              const CustomTextField(
                label: 'Nome Completo',
                prefixIcon: Icons.person_outline_rounded,
              ),
              const CustomTextField(
                label: 'E-mail',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const CustomTextField(
                label: 'Senha',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
              ),
              const CustomTextField(
                label: 'Confirmar Senha',
                prefixIcon: Icons.lock_reset_rounded,
                isPassword: true,
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Cadastrar',
                onPressed: () {},
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Já tem uma conta? ',
                    style: GoogleFonts.roboto(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'Faça Login',
                      style: GoogleFonts.roboto(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
