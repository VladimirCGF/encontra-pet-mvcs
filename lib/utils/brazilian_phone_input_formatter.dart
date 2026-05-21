import 'package:flutter/services.dart';

class BrazilianPhoneInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Remove qualquer caractere que não seja número
    final text = newValue.text.replaceAll(RegExp(r'\D'), '');
    final int textLength = text.length;

    if (textLength > 11) {
      return oldValue; // Limita o máximo a 11 dígitos
    }

    final StringBuffer newText = StringBuffer();

    // Aplica a formatação de acordo com o tamanho do texto digitado
    if (textLength >= 1) {
      newText.write('(');
      newText.write(text.substring(0, textLength >= 2 ? 2 : textLength));
    }
    if (textLength > 2) {
      newText.write(') ');
      newText.write(text.substring(2, textLength >= 7 ? 7 : textLength));
    }
    if (textLength > 7) {
      newText.write('-');
      newText.write(text.substring(7, textLength));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}