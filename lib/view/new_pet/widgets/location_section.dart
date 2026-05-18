import 'package:flutter/material.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:encontrapet/service/location_service.dart';

class LocationSection extends StatefulWidget {
  final TextEditingController locationController;

  const LocationSection({
    super.key,
    required this.locationController,
  });

  @override
  State<LocationSection> createState() => _LocationSectionState();
}

class _LocationSectionState extends State<LocationSection> {
  final LocationService _locationService = LocationService();
  bool _isLoadingLocation = false;

  Future<void> _fetchLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      final addressData = await _locationService.getCurrentAddress();
      if (addressData != null) {
        final bairro = addressData['bairro'] ?? '';
        final cidade = addressData['cidade'] ?? '';
        final estado = addressData['estado'] ?? '';

        List<String> parts = [];
        if (bairro.isNotEmpty) parts.add(bairro);
        if (cidade.isNotEmpty) parts.add(cidade);
        
        String locationStr = parts.join(', ');
        if (estado.isNotEmpty) {
          locationStr += locationStr.isNotEmpty ? ' - $estado' : estado;
        }

        widget.locationController.text = locationStr;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao obter localização: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingLocation = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Location text field label
          Text(
            'Última localização',
            style: GoogleFonts.roboto(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),

          // Location text field
          TextFormField(
            controller: widget.locationController,
            style: GoogleFonts.roboto(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: 'Bairro, cidade - estado',
              hintStyle: GoogleFonts.roboto(color: Colors.grey[400], fontSize: 14),
              filled: true,
              fillColor: AppColors.background,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              prefixIcon: const Icon(
                Icons.location_on_outlined,
                color: Color(0xFF00B4FF),
                size: 20,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Color(0xFF00B4FF), width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // "Usar localização atual" button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton.icon(
              onPressed: _isLoadingLocation ? null : _fetchLocation,
              icon: _isLoadingLocation 
                ? const SizedBox(
                    width: 18, height: 18, 
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.near_me_outlined, color: Color(0xFF00B4FF), size: 18),
              label: Text(
                _isLoadingLocation ? 'Obtendo localização...' : 'Usar localização atual',
                style: GoogleFonts.roboto(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: _isLoadingLocation ? Colors.grey : const Color(0xFF00B4FF),
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: _isLoadingLocation ? Colors.grey : const Color(0xFF00B4FF), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

