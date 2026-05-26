import 'dart:io';
import 'package:flutter/material.dart';
import 'package:encontrapet/view/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:encontrapet/controller/pet_controller.dart';
import 'package:encontrapet/model/pet_model.dart';
import '../../edit_pet/edit_pet_screen.dart';


class MyPetCard extends StatelessWidget {
  final PetModel pet;

  const MyPetCard({super.key, required this.pet});

  void _showDeleteDialog(BuildContext context, PetController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Excluir Pet?',
          style: GoogleFonts.roboto(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
        ),
        content: Text(
          'Tem certeza que deseja excluir as informações de ${pet.name}? Esta ação não poderá ser desfeita.',
          style: GoogleFonts.roboto(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: GoogleFonts.roboto(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removePet(pet.id!);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pet excluído com sucesso!'), backgroundColor: Colors.redAccent),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: Text('Excluir', style: GoogleFonts.roboto(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _navigateToEdit(BuildContext context) {
    // Parseando as strings formatadas para extrair os valores originais
    final breedParts = pet.breed.split(' - ');
    final type = breedParts.isNotEmpty ? breedParts[0] : 'Cachorro';
    final breedStr = breedParts.length > 1 ? breedParts[1] : pet.breed;
    final color = breedParts.length > 2 ? breedParts[2] : '';

    final dateParts = pet.date.split(' | ');
    final dateStr = dateParts.isNotEmpty ? dateParts[0] : pet.date;
    final description = dateParts.length > 1 ? dateParts[1] : '';

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPetScreen(
          name: pet.name,
          type: type,
          breed: breedStr,
          color: color,
          age: '', // Idade não estava sendo enviada para a Home no MVP
          location: pet.location,
          date: dateStr,
          originalPetId: pet.id!,
          imageUrl: pet.imageUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = pet.imageUrl.startsWith('http');
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header da imagem
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: Hero(
                tag: 'pet_image_my_pets_${pet.id ?? pet.hashCode}',
                child: isNetworkImage
                    ? Image.network(pet.imageUrl, fit: BoxFit.cover, height: 180, width: double.infinity, cacheWidth: 600)
                    : Image.file(
                        File(pet.imageUrl),
                        fit: BoxFit.cover,
                        height: 180,
                        width: double.infinity,
                        errorBuilder: (c, e, s) => const SizedBox(
                          height: 180,
                          width: double.infinity,
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
                        ),
                      ),
              ),
            ),
          ),
          
          // Informações
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 16, color: AppColors.primary),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        pet.location,
                        style: GoogleFonts.roboto(fontSize: 14, color: AppColors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(color: AppColors.background),
                ),

                // Botões de Ação
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _navigateToEdit(context),
                        icon: const Icon(Icons.edit_outlined, size: 18, color: AppColors.primary),
                        label: const Text('Editar', style: TextStyle(color: AppColors.primary)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showDeleteDialog(context, context.read<PetController>()),
                        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.redAccent),
                        label: const Text('Excluir', style: TextStyle(color: Colors.redAccent)),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
