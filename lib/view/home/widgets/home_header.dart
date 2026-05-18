import 'package:flutter/material.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../../controller/auth_controller.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final user = authController.currentUser;

    final name = user?.name ?? 'Usuário';
    final email = user?.email ?? '';
    final phone = (user?.phone == null || user!.phone!.isEmpty) ? 'Sem telefone cadastrado' : user.phone;
    final isPending = user?.syncStatus == 'pending_update';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left: User Info (Avatar + Greeting)
            Row(
              children: [
                // Avatar
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300], // Cor de fundo do círculo cinza claro
                    border: Border.all(
                      color: Colors.white,
                      width: 2.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,            // Ícone da silhueta cinza escura
                      size: 32,                // Proporcional ao tamanho de 48 do Container
                      color: Colors.grey[600], // Cor da silhueta
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Greeting Column
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá,',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      name,
                      style: GoogleFonts.roboto(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
