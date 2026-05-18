import 'package:flutter/material.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'delete_pet_dialog.dart';
import '../../edit_pet/edit_pet_screen.dart';

class MyPetCard extends StatelessWidget {
  final String name;
  final String breed;
  final String age;
  final String location;
  final String imageUrl;
  final bool isLost;

  const MyPetCard({
    super.key,
    required this.name,
    required this.breed,
    required this.age,
    required this.location,
    required this.imageUrl,
    required this.isLost,
  });

  @override
  Widget build(BuildContext context) {
    final badgeBgColor = isLost ? const Color(0xFFFDF3E7) : const Color(0xFFEAF8F0);
    final badgeTextColor = isLost ? const Color(0xFFD97706) : const Color(0xFF16A34A);
    final badgeDotColor = isLost ? const Color(0xFFF97316) : const Color(0xFF22C55E);
    final badgeText = isLost ? 'Perdido' : 'Encontrado';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top: pet info row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Pet photo (circular)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, _) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.pets, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Pet info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.roboto(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$breed · $age',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              color: Color(0xFF00B4FF), size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: GoogleFonts.roboto(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: badgeDotColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        badgeText,
                        style: GoogleFonts.roboto(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: badgeTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: Colors.grey[100]),

          // Bottom: action buttons
          IntrinsicHeight(
            child: Row(
              children: [
                // Editar
                Expanded(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditPetScreen(
                            name: name,
                            type: 'Cachorro',
                            breed: breed,
                            color: 'Variado',
                            age: age,
                            location: location,
                            date: '01/01/2025',
                            description: '',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.textPrimary),
                    label: Text(
                      'Editar',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20)),
                      ),
                    ),
                  ),
                ),

                // Vertical divider
                VerticalDivider(width: 1, color: Colors.grey[100]),

                // Excluir
                Expanded(
                  child: TextButton.icon(
                    onPressed: () async {
                      await showDeletePetDialog(context, name);
                    },
                    icon: const Icon(Icons.delete_outline_rounded,
                        size: 18, color: AppColors.error),
                    label: Text(
                      'Excluir',
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.error,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(20)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
