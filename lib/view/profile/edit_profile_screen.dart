import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encontrapet/controller/auth_controller.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:encontrapet/view/widgets/custom_button.dart';
import 'package:encontrapet/view/widgets/custom_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pré-carrega os dados atuais do usuário logado
    final user = Provider.of<AuthController>(context, listen: false).currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O nome não pode estar em branco!')),
      );
      return;
    }

    final authController = Provider.of<AuthController>(context, listen: false);
    await authController.updateProfile(name, phone);

    if (!mounted) return;

    if (authController.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authController.errorMessage!)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Perfil atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context); // Volta para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthController>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Editar Perfil',
          style: GoogleFonts.roboto(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Foto Placeholder
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: const DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?auto=format&fit=crop&q=80&w=200'),
                          fit: BoxFit.cover,
                        ),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 4.0,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 36),

              // Inputs
              Text(
                'NOME COMPLET0',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                label: 'Nome',
                prefixIcon: Icons.person_outline_rounded,
                controller: _nameController,
              ),
              const SizedBox(height: 24),

              Text(
                'CONTATO (TELEFONE / WHATSAPP)',
                style: GoogleFonts.roboto(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              CustomTextField(
                label: 'Contato',
                prefixIcon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                controller: _phoneController,
              ),
              const SizedBox(height: 40),

              // Botão Salvar
              isLoading
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : CustomButton(
                      text: 'Salvar Alterações',
                      onPressed: _handleSave,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
