import 'package:flutter/material.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;

  const HomeSearchBar({super.key, this.onChanged});

  @override
  State<HomeSearchBar> createState() => _HomeSearchBarState();
}

class _HomeSearchBarState extends State<HomeSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _controller,
          onChanged: (value) {
            setState(() {
              _hasText = value.isNotEmpty;
            });
            widget.onChanged?.call(value);
          },
          decoration: InputDecoration(
            hintText: 'Buscar por nome, raça ou local',
            hintStyle: GoogleFonts.roboto(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.grey,
              size: 22,
            ),
            suffixIcon: _hasText
                ? GestureDetector(
                    onTap: () {
                      _controller.clear();
                      setState(() {
                        _hasText = false;
                      });
                      widget.onChanged?.call('');
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.grey,
                      size: 20,
                    ),
                  )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          ),
          style: GoogleFonts.roboto(
            color: AppColors.textPrimary,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
