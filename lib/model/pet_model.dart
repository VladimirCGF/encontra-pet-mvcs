class PetModel {
  final String? id;
  final String name;
  final String breed;
  final String imageUrl;
  final String location;
  final String date;
  final bool isLost;

  PetModel({
    this.id,
    required this.name,
    required this.breed,
    required this.imageUrl,
    required this.location,
    required this.date,
    required this.isLost,
  });

  factory PetModel.fromMap(Map<String, dynamic> map) {
    return PetModel(
      id: map['id'] as String?,
      name: map['name'] as String,
      breed: map['breed'] as String,
      imageUrl: map['imageUrl'] as String,
      location: map['location'] as String,
      date: map['date'] as String,
      isLost: map['isLost'] == 1 || map['isLost'] == true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'imageUrl': imageUrl,
      'location': location,
      'date': date,
      'isLost': isLost ? 1 : 0, // SQLite compatibility
    };
  }
}
