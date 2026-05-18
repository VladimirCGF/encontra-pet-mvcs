import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:encontrapet/controller/pet_controller.dart';
import 'package:encontrapet/model/pet_model.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

import 'widgets/basic_info_section.dart';
import 'widgets/disappearance_section.dart';
import 'widgets/location_section.dart';
import 'widgets/photos_section.dart';

class NewPetScreen extends StatefulWidget {
  const NewPetScreen({super.key});

  @override
  State<NewPetScreen> createState() => _NewPetScreenState();
}

class _NewPetScreenState extends State<NewPetScreen> {
  // Controladores do formulário
  final _nameController = TextEditingController();
  final _breedController = TextEditingController();
  final _colorController = TextEditingController();
  final _dateController = TextEditingController();
  final _locationController = TextEditingController();

  String _selectedType = 'Cachorro';
  String? _imagePath;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _breedController.dispose();
    _colorController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _processImagePicker(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 70);
    
    if (image != null) {
      setState(() {
        _imagePath = image.path;
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
                title: Text(
                  'Tirar Foto',
                  style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                  _processImagePicker(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.primary),
                title: Text(
                  'Escolher da Galeria',
                  style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
                ),
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

  void _pickImage() {
    _showImageSourceActionSheet(context);
  }

  Future<void> _handlePublish() async {
    // 1. Validação básica (apenas Foto e Localização são estritamente obrigatórios)
    if (_locationController.text.trim().isEmpty || _imagePath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, preencha a localização e adicione uma foto!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() { _isSubmitting = true; });

    // 2. Fallbacks automáticos (Nome e Data)
    final finalName = _nameController.text.trim().isEmpty 
        ? 'Sem Identificação' 
        : _nameController.text.trim();

    String finalDate = _dateController.text.trim();
    if (finalDate.isEmpty) {
      final now = DateTime.now();
      final day = now.day.toString().padLeft(2, '0');
      final month = now.month.toString().padLeft(2, '0');
      final year = now.year.toString();
      finalDate = '$day/$month/$year';
    }

    // 3. Construção do modelo do Pet
    // Concatenamos os campos extras para respeitar o schema atual do banco de dados (SQLite)
    final pet = PetModel(
      name: finalName,
      breed: '$_selectedType - ${_breedController.text.trim()} - ${_colorController.text.trim()}',
      imageUrl: _imagePath!, // Salvamos o caminho local (Upload ocorrerá em background)
      location: _locationController.text.trim(),
      date: finalDate,
      isLost: true, // A tela é para pet perdido
    );

    // 3. Envia para o Controller (Latência Zero via SQLite)
    final petController = Provider.of<PetController>(context, listen: false);
    await petController.addPet(pet);

    if (!mounted) return;
    
    setState(() { _isSubmitting = false; });

    // 4. Sucesso e fechamento da tela
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pet cadastrado! A sincronização ocorrerá em segundo plano.'),
        backgroundColor: Colors.green,
      ),
    );
    Navigator.pop(context);
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
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back, color: AppColors.primary, size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cadastrar pet',
                        style: GoogleFonts.roboto(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Quanto mais detalhes, melhor.',
                        style: GoogleFonts.roboto(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Scrollable form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    BasicInfoSection(
                      nameController: _nameController,
                      breedController: _breedController,
                      colorController: _colorController,
                      selectedType: _selectedType,
                      onTypeChanged: (type) {
                        setState(() {
                          _selectedType = type;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    LocationSection(
                      locationController: _locationController,
                    ),
                    const SizedBox(height: 16),
                    PhotosSection(
                      imagePath: _imagePath,
                      onPickImage: _pickImage,
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Publish button
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _handlePublish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00B4FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: _isSubmitting 
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'Publicar pet perdido',
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
