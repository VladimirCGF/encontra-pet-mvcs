import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:encontrapet/controller/pet_controller.dart';
import 'package:encontrapet/model/pet_model.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../new_pet/widgets/basic_info_section.dart';
import '../new_pet/widgets/disappearance_section.dart';
import '../new_pet/widgets/location_section.dart';
import '../new_pet/widgets/photos_section.dart';

class EditPetScreen extends StatefulWidget {
  final String originalPetId;
  final String name;
  final String type;
  final String breed;
  final String color;
  final String age;
  final String location;
  final String date;
  final String description;
  final String imageUrl;

  const EditPetScreen({
    super.key,
    required this.originalPetId,
    required this.name,
    required this.type,
    required this.breed,
    required this.color,
    required this.age,
    required this.location,
    required this.date,
    required this.description,
    required this.imageUrl,
  });

  @override
  State<EditPetScreen> createState() => _EditPetScreenState();
}

class _EditPetScreenState extends State<EditPetScreen> {
  late TextEditingController _nameController;
  late TextEditingController _breedController;
  late TextEditingController _colorController;
  late TextEditingController _ageController;
  late TextEditingController _dateController;
  late TextEditingController _descriptionController;
  late TextEditingController _locationController;

  late String _selectedType;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _breedController = TextEditingController(text: widget.breed);
    _colorController = TextEditingController(text: widget.color);
    _ageController = TextEditingController(text: widget.age);
    _dateController = TextEditingController(text: widget.date);
    _descriptionController = TextEditingController(text: widget.description);
    _locationController = TextEditingController(text: widget.location);
    _selectedType = widget.type;
    _imagePath = widget.imageUrl; // Inicia com a imagem original (URL ou local)
  }

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _ageController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _processImagePicker(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 70);
    
    if (image != null) {
      setState(() {
        _imagePath = image.path; // Se selecionar nova foto, substitui o URL por um caminho local
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.primary),
                title: Text('Tirar Foto', style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.of(context).pop();
                  _processImagePicker(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                title: Text('Escolher da Galeria', style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.of(context).pop();
                  _processImagePicker(ImageSource.gallery);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Custom AppBar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Editar pet', style: GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      Text('Atualize as informações do pet.', style: GoogleFonts.roboto(fontSize: 13, color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable form — pre-filled with pet data
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    BasicInfoSection(
                      nameController: _nameController,
                      breedController: _breedController,
                      colorController: _colorController,
                      ageController: _ageController,
                      selectedType: _selectedType,
                      onTypeChanged: (type) => setState(() => _selectedType = type),
                    ),
                    const SizedBox(height: 16),
                    DisappearanceSection(
                      dateController: _dateController,
                      descriptionController: _descriptionController,
                    ),
                    const SizedBox(height: 16),
                    LocationSection(locationController: _locationController),
                    const SizedBox(height: 16),
                    PhotosSection(
                      imagePath: _imagePath,
                      onPickImage: () => _showImageSourceActionSheet(context),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Save button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -4)),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    final finalName = _nameController.text.trim().isEmpty ? 'Sem Identificação' : _nameController.text.trim();
                    final finalDate = _dateController.text.trim().isEmpty 
                        ? '${DateTime.now().day.toString().padLeft(2, '0')}/${DateTime.now().month.toString().padLeft(2, '0')}/${DateTime.now().year}' 
                        : _dateController.text.trim();

                    final updatedPet = PetModel(
                      id: widget.originalPetId,
                      name: finalName,
                      breed: '$_selectedType - ${_breedController.text.trim()} - ${_colorController.text.trim()}',
                      imageUrl: _imagePath ?? '', 
                      location: _locationController.text.trim(),
                      date: '$finalDate | ${_descriptionController.text.trim()}',
                      isLost: true,
                    );
                    
                    context.read<PetController>().editPet(updatedPet);
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Alterações salvas! Sincronizando em segundo plano...'), backgroundColor: Colors.green),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: Text('Salvar alterações', style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
