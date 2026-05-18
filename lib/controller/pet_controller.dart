import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../model/pet_model.dart';
import '../service/pet_service.dart';

class PetController extends ChangeNotifier {
  final PetService _petService = PetService();

  List<PetModel> _allPets = [];
  bool _isLoading = false;
  String _searchQuery = '';
  String _selectedCategory = 'Todos';
  List<PetModel>? _cachedFeedPets;

  // Setters reativos para busca e filtro (invalidam o cache)
  set searchQuery(String value) {
    _searchQuery = value;
    _cachedFeedPets = null;
    notifyListeners();
  }

  set selectedCategory(String value) {
    _selectedCategory = value;
    _cachedFeedPets = null;
    notifyListeners();
  }

  String get searchQuery => _searchQuery;
  String get selectedCategory => _selectedCategory;

  // Feed filtrado por categoria e busca textual (cacheado em memória)
  List<PetModel> get feedPets {
    _cachedFeedPets ??= _computeFeedPets();
    return _cachedFeedPets!;
  }

  List<PetModel> _computeFeedPets() {
    List<PetModel> filtered = _allPets;

    // 1. Filtro por categoria
    if (_selectedCategory != 'Todos') {
      filtered = filtered.where((pet) {
        final breedLower = pet.breed.toLowerCase();
        switch (_selectedCategory) {
          case 'Cachorros':
            return breedLower.startsWith('cachorro');
          case 'Gatos':
            return breedLower.startsWith('gato');
          case 'Outros':
            return !breedLower.startsWith('cachorro') && !breedLower.startsWith('gato');
          default:
            return true;
        }
      }).toList();
    }

    // 2. Filtro por texto de busca
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((pet) {
        return pet.name.toLowerCase().contains(query) ||
               pet.breed.toLowerCase().contains(query) ||
               pet.location.toLowerCase().contains(query);
      }).toList();
    }

    return filtered;
  }
  
  // Filtra apenas os pets pertencentes ao usuário logado atual
  List<PetModel> get myPets {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    if (currentUserId == null) return [];
    return _allPets.where((pet) => pet.userId == currentUserId).toList();
  }

  bool get isLoading => _isLoading;

  Future<void> fetchAllPets() async {
    _isLoading = true;
    notifyListeners();

    try {
      _allPets = await _petService.getAllPets();
      _cachedFeedPets = null; // Invalida o cache ao recarregar
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
      final newPet = await _petService.createPet(pet);
      _allPets.add(newPet);
      _cachedFeedPets = null; // Invalida o cache
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
        _cachedFeedPets = null; // Invalida o cache
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Erro ao editar: $e');
    }
  }

  Future<void> removePet(String id) async {
    try {
      await _petService.deletePet(id);
      _allPets.removeWhere((p) => p.id == id);
      _cachedFeedPets = null; // Invalida o cache
      notifyListeners();
    } catch (e) {
      debugPrint('Erro ao deletar: $e');
    }
  }
}
