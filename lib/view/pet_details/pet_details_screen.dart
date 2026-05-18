import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PetDetailsScreen extends StatelessWidget {
  final String name;
  final String breed;
  final String imageUrl;
  final String location;
  final String date;
  final bool isLost;
  final String description;
  final String ownerName;
  final String ownerPhone;

  const PetDetailsScreen({
    super.key,
    required this.name,
    required this.breed,
    required this.imageUrl,
    required this.location,
    required this.date,
    required this.isLost,
    this.description =
        'Animal muito dócil e amigável. Usa coleira azul com placa de identificação. Pode estar assustado.',
    this.ownerName = 'Vladimir Silva',
    this.ownerPhone = '(11) 99999-9999',
  });

  @override
  Widget build(BuildContext context) {
    final badgeBgColor = isLost
        ? const Color(0xFFFDF3E7)
        : const Color(0xFFEAF8F0);
    final badgeTextColor = isLost
        ? const Color(0xFFD97706)
        : const Color(0xFF16A34A);
    final badgeDotColor = isLost
        ? const Color(0xFFF97316)
        : const Color(0xFF22C55E);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Hero image with overlaid elements
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image section (Stack)
                    Stack(
                      children: [
                        // Pet Image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(28),
                          ),
                          child: Image.network(
                            imageUrl,
                            height: 320,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, _) => Container(
                              height: 320,
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.pets,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ),
                        // Safe area padding for back button
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Back button
                                GestureDetector(
                                  onTap: () => Navigator.pop(context),
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(
                                        alpha: 0.9,
                                      ),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.1,
                                          ),
                                          blurRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.arrow_back,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                // Status badge overlaid
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 7,
                                  ),
                                  decoration: BoxDecoration(
                                    color: badgeBgColor,
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 7,
                                        height: 7,
                                        decoration: BoxDecoration(
                                          color: badgeDotColor,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        isLost ? 'Perdido' : 'Encontrado',
                                        style: GoogleFonts.roboto(
                                          color: badgeTextColor,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Details content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Name
                          Text(
                            name,
                            style: GoogleFonts.roboto(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            breed,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Location
                          _buildInfoRow(Icons.location_on_outlined, location),
                          const SizedBox(height: 10),

                          // Date
                          _buildInfoRow(Icons.calendar_month_outlined, date),
                          const SizedBox(height: 20),

                          // Description
                          Text(
                            'Descrição',
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            description,
                            style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                              height: 1.6,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Owner contact card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.04),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Owner avatar
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFFE1F5FE),
                                  ),
                                  child: const Icon(
                                    Icons.person_outline_rounded,
                                    color: AppColors.primary,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ownerName,
                                        style: GoogleFonts.roboto(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      Text(
                                        ownerPhone,
                                        style: GoogleFonts.roboto(
                                          fontSize: 13,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed CTA button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.phone_outlined, size: 20),
                  label: Text(
                    'Entrar em contato',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF00B4FF), size: 18),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.roboto(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }


}
