import 'package:flutter/material.dart';
import 'app_colors.dart';

abstract class AppTypography {
  // ===========================================================================
  // 1. TAMANHOS DAS FONTES (Font Sizes - Padrão IHC / Acessibilidade Mobile)
  // ===========================================================================
  static const double sizeCaption = 12.0;    // Rótulos secundários e micro-textos
  static const double sizeBodyText = 14.0;   // Tamanho mínimo ideal para leitura fluida
  static const double sizeSubtitle = 16.0;   // Subtítulos ou elementos de destaque
  static const double sizeTitleSmall = 20.0; // Títulos secundários ou de cartões
  static const double sizeTitleLarge = 24.0; // Título principal de telas (Headers)

  // ===========================================================================
  // 2. ESTILOS PRONTOS (Text Styles com Vínculo Direto às Cores)
  // ===========================================================================

  // Título Grande (Ex: Nome da tela no Header)
  static const TextStyle titleLarge = TextStyle(
    fontSize: sizeTitleLarge,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary, // Cor clara para contraste em fundos escuros
    letterSpacing: -0.5,
  );

  // Título Menor (Ex: Títulos dentro de Cards ou Seções)
  static const TextStyle titleSmall = TextStyle(
    fontSize: sizeTitleSmall,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  // Subtítulo (Ex: Descrições curtas logo abaixo do título principal)
  static const TextStyle subtitle = TextStyle(
    fontSize: sizeSubtitle,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary, // Tom cinza para menor peso visual
  );

  // Texto de Corpo (Onde o usuário consome as informações principais do app)
  static const TextStyle body = TextStyle(
    fontSize: sizeBodyText,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.4, // IHC: Espaçamento de linha maior para evitar fadiga ocular
  );

  // Legendas e Rótulos Menores
  static const TextStyle caption = TextStyle(
    fontSize: sizeCaption,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
  );
}