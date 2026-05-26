import 'package:flutter_test/flutter_test.dart';

// Replica a lógica de sanitização de phone da PetDetailsScreen
// para validação isolada sem necessidade de widget binding.
String sanitizePhone(String phone) {
  String digits = phone.replaceAll(RegExp(r'[^\d+]'), '');
  if (digits.startsWith('+')) return digits;
  if (digits.startsWith('55') && digits.length >= 12) return '+$digits';
  return '+55$digits';
}

String buildWhatsAppUrl(String phone, String petName) {
  final sanitized = sanitizePhone(phone);
  final message = Uri.encodeComponent(
    'Olá! Vi o anúncio do pet *$petName* no EncontraPet e gostaria de obter mais informações.',
  );
  return 'https://wa.me/$sanitized?text=$message';
}

void main() {
  group('sanitizePhone()', () {
    test('Número com máscara brasileira deve ser sanitizado corretamente', () {
      expect(sanitizePhone('(11) 99999-8888'), '+5511999998888');
    });

    test('Número sem DDI deve receber +55', () {
      expect(sanitizePhone('11999998888'), '+5511999998888');
    });

    test('Número já com DDI +55 não deve duplicar', () {
      expect(sanitizePhone('+5511999998888'), '+5511999998888');
    });

    test('Número com DDI sem + deve receber + e não duplicar 55', () {
      expect(sanitizePhone('5511999998888'), '+5511999998888');
    });

    test('Telefone fixo de 8 dígitos deve receber DDI e DDD', () {
      expect(sanitizePhone('(11) 3333-4444'), '+551133334444');
    });
  });

  group('buildWhatsAppUrl()', () {
    test('URL deve conter o número sanitizado e o nome do pet codificado', () {
      final url = buildWhatsAppUrl('(11) 99999-8888', 'Rex');
      expect(url, contains('wa.me/+5511999998888'));
      expect(url, contains('Rex'));
    });

    test('Mensagem deve conter o nome do pet em negrito Markdown', () {
      final url = buildWhatsAppUrl('11999998888', 'Bolinha');
      expect(url, contains('*Bolinha*'));
    });

    test('URL deve ser válida e começar com https://wa.me/', () {
      final url = buildWhatsAppUrl('11999998888', 'Mimi');
      expect(url.startsWith('https://wa.me/'), isTrue);
    });
  });
}
