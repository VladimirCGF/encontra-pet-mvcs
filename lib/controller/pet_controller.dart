import 'package:flutter/material.dart';
import '../model/pet_model.dart';

class PetController extends ChangeNotifier {
  // Dados mockados provisórios para não quebrar a UI
  final List<PetModel> _feedPets = [
    PetModel(
      id: '1',
      name: 'Thor',
      breed: 'Golden Retriever',
      imageUrl: 'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&q=80&w=600',
      location: 'Vila Madalena, SP',
      date: 'Hoje, 14:20',
      isLost: true,
    ),
    PetModel(
      id: '2',
      name: 'Mel',
      breed: 'SRD laranja',
      imageUrl: 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?auto=format&fit=crop&q=80&w=600',
      location: 'Pinheiros, SP',
      date: 'Ontem, 09:10',
      isLost: true,
    ),
    PetModel(
      id: '3',
      name: 'Nina',
      breed: 'Poodle',
      imageUrl: 'https://images.unsplash.com/photo-1583511655857-d19b40a7a54e?auto=format&fit=crop&q=80&w=600',
      location: 'Moema, SP',
      date: '2 dias atrás',
      isLost: false,
    ),
    PetModel(
      id: '4',
      name: 'Salem',
      breed: 'SRD preto e branco',
      imageUrl: 'https://images.unsplash.com/photo-1573865526739-10659fec78a5?auto=format&fit=crop&q=80&w=600',
      location: 'Vila Mariana, SP',
      date: '3 dias atrás',
      isLost: true,
    ),
  ];

  final List<PetModel> _myPets = [
    PetModel(
      id: '5',
      name: 'Bento',
      breed: 'Beagle',
      imageUrl: 'https://images.unsplash.com/photo-1505628346881-b72b27e84530?auto=format&fit=crop&q=80&w=300',
      location: 'Perdizes, SP',
      date: '4 anos', // "date" está agindo como "age" no my_pets no mock antigo
      isLost: true,
    ),
    PetModel(
      id: '6',
      name: 'Luna',
      breed: 'Siamês',
      imageUrl: 'https://images.unsplash.com/photo-1513245543132-31f507417b26?auto=format&fit=crop&q=80&w=300',
      location: 'Encontrada em casa',
      date: '2 anos',
      isLost: false,
    ),
  ];

  List<PetModel> get feedPets => _feedPets;
  List<PetModel> get myPets => _myPets;

  // Futuros métodos: addPet, removePet, etc...
}
