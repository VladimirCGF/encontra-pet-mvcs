import 'package:flutter/material.dart';
import '../model/pet_model.dart';
import '../service/pet_service.dart';

class PetController extends ChangeNotifier {
  final PetService _petService = PetService();

  List<PetModel> _allPets = [];
  bool _isLoading = false;

  // Filtragem básica, no futuro você pode filtrar pelo ID do usuário logado
  List<PetModel> get feedPets => _allPets;
  List<PetModel> get myPets => _allPets.where((pet) => pet.isLost == false).toList(); // Apenas exemplo
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
}
