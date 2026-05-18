import 'package:flutter/material.dart';
import '../model/pet_model.dart';
import '../service/pet_service.dart';

class PetController extends ChangeNotifier {
  final PetService _petService = PetService();

  List<PetModel> _allPets = [];
  bool _isLoading = false;

  // Filtragem básica, no futuro você pode filtrar pelo ID do usuário logado
  List<PetModel> get feedPets => _allPets;
  List<PetModel> get myPets => _allPets; // MVP: Exibe todos os pets gerados localmente pelo usuário
  bool get isLoading => _isLoading;

  Future<void> fetchAllPets() async {
    _isLoading = true;
    notifyListeners(); // Avisa a View para mostrar o skeleton ou loading

    try {
      _allPets = await _petService.getAllPets();
    } catch (e) {
      debugPrint('Erro ao carregar pets: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPet(PetModel pet) async {
    _isLoading = true;
    notifyListeners();

    try {
      // O Service salva no SQLite imediatamente e já marca para tentar o sync!
      final newPet = await _petService.createPet(pet);
      _allPets.add(newPet);
    } catch (e) {
      debugPrint('Erro ao adicionar pet: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editPet(PetModel pet) async {
    try {
      final updatedPet = await _petService.updatePet(pet);
      final index = _allPets.indexWhere((p) => p.id == updatedPet.id);
      if (index != -1) {
        _allPets[index] = updatedPet;
        notifyListeners(); // Atualiza a tela com o pet modificado imediatamente
      }
    } catch (e) {
      debugPrint('Erro ao editar: $e');
    }
  }

  Future<void> removePet(String id) async {
    try {
      await _petService.deletePet(id);
      _allPets.removeWhere((p) => p.id == id);
      notifyListeners(); // Remove o pet da tela instantaneamente
    } catch (e) {
      debugPrint('Erro ao deletar: $e');
    }
  }
}
