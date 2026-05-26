import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:encontrapet/model/pet_model.dart';
import 'package:encontrapet/model/user_model.dart';
import 'package:encontrapet/controller/pet_controller.dart';
import 'package:encontrapet/controller/auth_controller.dart';
import 'package:encontrapet/view/main_shell.dart';

class MockPetController extends ChangeNotifier implements PetController {
  final List<PetModel> mockFeedPets;
  final List<PetModel> mockMyPets;
  final bool mockIsLoading;

  MockPetController({
    required this.mockFeedPets,
    required this.mockMyPets,
    this.mockIsLoading = false,
  });

  @override
  List<PetModel> get feedPets => mockFeedPets;

  @override
  List<PetModel> get myPets => mockMyPets;

  @override
  bool get isLoading => mockIsLoading;

  @override
  String get searchQuery => '';

  @override
  set searchQuery(String value) {}

  @override
  String get selectedCategory => 'Todos';

  @override
  set selectedCategory(String value) {}

  @override
  Future<void> fetchAllPets() async {
    // No-op
  }

  @override
  Future<void> addPet(PetModel pet) async {
    // No-op
  }

  @override
  Future<void> editPet(PetModel pet) async {
    // No-op
  }

  @override
  Future<void> removePet(String id) async {
    // No-op
  }
}

class MockAuthController extends ChangeNotifier implements AuthController {
  @override
  UserModel? get currentUser => UserModel(
        id: 'user-456',
        email: 'test@example.com',
        name: 'Test User',
        phone: '11999999999',
      );

  @override
  bool get isAuthenticated => true;

  @override
  bool get isLoading => false;

  @override
  String? get errorMessage => null;

  @override
  Future<bool> loadSession() async => true;

  @override
  Future<bool> login(String email, String password, bool keepLoggedIn) async => true;

  @override
  Future<void> logout() async {}

  @override
  Future<bool> signUp(String email, String password, String name, String phone) async => true;

  @override
  Future<void> updateProfile(String name, String phone) async {}
}

void main() {
  testWidgets('Não deve haver colisão de Hero tags entre HomeScreen e MyPetsScreen na MainShell', (WidgetTester tester) async {
    // 1. Criar um pet que estará tanto no feed geral quanto nos meus pets do usuário
    final doubleRegisteredPet = PetModel(
      id: 'pet-123',
      userId: 'user-456',
      name: 'Bolinha',
      breed: 'Poodle',
      imageUrl: 'http://example.com/bolinha.jpg',
      location: 'São Paulo, SP',
      date: 'Hoje',
      isLost: true,
    );

    final mockPetController = MockPetController(
      mockFeedPets: [doubleRegisteredPet],
      mockMyPets: [doubleRegisteredPet],
    );

    final mockAuthController = MockAuthController();

    // 2. Renderizar a MainShell com os providers mockados
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<PetController>.value(value: mockPetController),
          ChangeNotifierProvider<AuthController>.value(value: mockAuthController),
        ],
        child: const MaterialApp(
          home: MainShell(),
        ),
      ),
    );

    // 3. Aguardar renderização inicial da Home
    await tester.pumpAndSettle();

    // 4. Mudar de aba para "Meus Pets" para forçar a renderização do MyPetCard.
    // Com isso, ambas as telas (Home e Meus Pets) terão renderizado seus respectivos cards de pet
    // dentro da árvore de widgets do IndexedStack.
    await tester.tap(find.text('Meus Pets'));
    await tester.pumpAndSettle();

    // 5. Validar que as Hero tags na árvore são distintas
    // Usamos skipOffstage: false para garantir que buscamos na árvore inteira,
    // incluindo a aba Home que agora está em segundo plano (offstage).
    final heroFinder = find.byType(Hero, skipOffstage: false);

    final Iterable<Hero> heroes = tester.widgetList<Hero>(heroFinder);
    final List<Object> petTags = heroes
        .map((h) => h.tag)
        .where((tag) => tag.toString().startsWith('pet_image_'))
        .toList();

    // Devem existir exatamente 2 tags do tipo pet_image_ (uma da Home e outra do Meus Pets)
    expect(petTags.length, 2, reason: 'Devem existir exatamente 2 widgets Hero de pets na árvore.');

    // Garantir que as tags são diferentes e estão escopadas corretamente
    expect(petTags[0], isNot(petTags[1]), reason: 'As tags dos widgets Hero na Home e Meus Pets colidiram!');
    expect(petTags, contains('pet_image_home_pet-123'));
    expect(petTags, contains('pet_image_my_pets_pet-123'));
  });
}
