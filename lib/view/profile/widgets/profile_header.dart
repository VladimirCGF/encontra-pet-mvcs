import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encontrapet/controller/auth_controller.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final user = authController.currentUser;

    final name = user?.name ?? 'Usuário';
    final email = user?.email ?? '';
    final phone = (user?.phone == null || user!.phone!.isEmpty) ? 'Sem telefone cadastrado' : user.phone;
    final isPending = user?.syncStatus == 'pending_update';

    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: const EdgeInsets.only(
        top: 24.0,
        left: 20.0,
        right: 20.0,
        bottom: 48.0, // Space for stats card overlap
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Screen Title
          Text(
            'Meu perfil',
            style: GoogleFonts.roboto(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),

          // User Info Column (Centered)
          Center(
            child: Column(
              children: [
                // Avatar
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey[300],
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
                      Icons.person,
                      size: 64,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Name + Offline Sync Status Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isPending) ...[
                      const SizedBox(width: 8),
                      const Tooltip(
                        message: 'Alterações salvas offline. Sincronizando quando houver conexão...',
                        child: Icon(
                          Icons.cloud_off_rounded,
                          color: Colors.white70,
                          size: 20,
                        ),
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 8),

                // Email
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      email,
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Phone
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.phone_outlined,
                      color: Colors.white70,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      phone!,
                      style: GoogleFonts.roboto(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
