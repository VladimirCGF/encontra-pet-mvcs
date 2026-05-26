import 'dart:io';

import 'package:encontrapet/service/user_service.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/pet_model.dart';

class PetDetailsScreen extends StatefulWidget {
  final PetModel pet;
  final String? heroTag;

  const PetDetailsScreen({super.key, required this.pet, this.heroTag});

  @override
  State<PetDetailsScreen> createState() => _PetDetailsScreenState();
}

class _PetDetailsScreenState extends State<PetDetailsScreen> {
  String? _ownerPhone;
  bool _isLoadingPhone = true;

  @override
  void initState() {
    super.initState();
    _loadOwnerPhone();
  }

  Future<void> _loadOwnerPhone() async {
    if (widget.pet.userId == null) {
      if (mounted) setState(() => _isLoadingPhone = false);
      return;
    }
    final phone = await UserService().getOwnerPhone(widget.pet.userId!);
    if (mounted) {
      setState(() {
        _ownerPhone = phone;
        _isLoadingPhone = false;
      });
    }
  }

  /// Sanitiza o número, remove formatação e adiciona DDI +55 se necessário.
  String _sanitizePhone(String phone) {
    // Remove todos os caracteres não numéricos
    String digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
    // Se o número já começa com '+', mantém como está
    if (digits.startsWith('+')) return digits;
    // Se começa com '55' e tem mais de 11 dígitos, assume que já tem DDI
    if (digits.startsWith('55') && digits.length >= 12) return '+$digits';
    // Caso contrário, adiciona o DDI do Brasil
    return '+55$digits';
  }

  Future<void> _launchWhatsApp() async {
    if (_ownerPhone == null || _ownerPhone!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Contato do anunciante não disponível.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
      return;
    }

    final sanitizedPhone = _sanitizePhone(_ownerPhone!);
    final message = Uri.encodeComponent(
      'Olá! Vi o anúncio do pet *${widget.pet.name}* no EncontraPet e gostaria de obter mais informações.',
    );
    final waUrl = Uri.parse('https://wa.me/$sanitizedPhone?text=$message');

    try {
      final launched = await launchUrl(
        waUrl,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir o WhatsApp.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível abrir o WhatsApp.'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = widget.pet.imageUrl.startsWith('http');

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
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Hero(
                              tag: widget.heroTag ?? 'pet_image_${widget.pet.id ?? widget.pet.hashCode}',
                              child: isNetworkImage
                                  ? Image.network(widget.pet.imageUrl, fit: BoxFit.cover, height: 350, width: double.infinity)
                                  : Image.file(
                                      File(widget.pet.imageUrl),
                                      fit: BoxFit.cover,
                                      height: 350,
                                      width: double.infinity,
                                      errorBuilder: (c, e, s) => const SizedBox(
                                        height: 350,
                                        width: double.infinity,
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      ),
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
                            widget.pet.name,
                            style: GoogleFonts.roboto(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.pet.breed,
                            style: GoogleFonts.roboto(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Location
                          _buildInfoRow(
                            Icons.location_on_outlined,
                            widget.pet.location,
                          ),
                          const SizedBox(height: 10),

                          // Date
                          _buildInfoRow(
                            Icons.calendar_month_outlined,
                            widget.pet.date,
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
                  onPressed: _isLoadingPhone ? null : _launchWhatsApp,
                  icon: _isLoadingPhone
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.chat_rounded, size: 22),
                  label: Text(
                    'Entrar em contato',
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isLoadingPhone
                        ? AppColors.primary.withValues(alpha: 0.6)
                        : AppColors.primary,
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
