import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encontrapet/controller/auth_controller.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:encontrapet/view/widgets/custom_button.dart';
import 'package:encontrapet/view/widgets/custom_text_field.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignup() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    // Validações Básicas
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }

    // Validação de formato de E-mail
    final emailRegex = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (!emailRegex.hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite um e-mail válido.')),
      );
      return;
    }

    // Validação do tamanho da senha
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('A senha deve ter no mínimo 8 caracteres.')),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não coincidem!')),
      );
      return;
    }

    // Usando Provider para acessar o controller
    final authController = Provider.of<AuthController>(context, listen: false);
    
    // Tenta fazer o cadastro real no Supabase
    final success = await authController.signUp(email, password, name);

    // Certifica-se de que a tela ainda está montada antes de mostrar notificações/navegar
    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
      // Como a navegação do EncontraPet geralmente abre a home após o login/signup,
      // podemos simplesmente voltar para a tela de Login ou empurrar a Home.
      // Aqui, vamos voltar para o Login page para ele entrar com as credenciais.
      Navigator.pop(context); 
    } else {
      // Mostra o erro retornado pelo Controller
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authController.errorMessage ?? 'Erro desconhecido ao cadastrar.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Escuta o AuthController para saber se deve exibir o loading
    final isLoading = context.watch<AuthController>().isLoading;

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
              CustomTextField(
                label: 'Nome Completo',
                prefixIcon: Icons.person_outline_rounded,
                controller: _nameController,
              ),
              CustomTextField(
                label: 'E-mail',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
              ),
              CustomTextField(
                label: 'Senha',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                controller: _passwordController,
              ),
              CustomTextField(
                label: 'Confirmar Senha',
                prefixIcon: Icons.lock_reset_rounded,
                isPassword: true,
                controller: _confirmPasswordController,
              ),
              const SizedBox(height: 32),
              // Substitui o botão por um Loading se estiver carregando
              isLoading 
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : CustomButton(
                      text: 'Cadastrar',
                      onPressed: _handleSignup,
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
