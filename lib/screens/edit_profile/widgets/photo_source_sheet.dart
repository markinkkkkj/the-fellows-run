import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

import 'photo_source_tile.dart';

/// Origem escolhida no bottom sheet de foto de perfil.
enum PhotoSource { camera, gallery, remove }

/// Abre o bottom sheet de escolha da foto de perfil e devolve a opção
/// escolhida (ou null se o usuário fechar sem escolher). [hasPhoto] controla
/// se a opção de remover é exibida.
Future<PhotoSource?> showPhotoSourceSheet(
  BuildContext context, {
  required bool hasPhoto,
}) {
  final theme = Theme.of(context).colorScheme;
  return showModalBottomSheet<PhotoSource>(
    context: context,
    backgroundColor: AppColors.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Alterar foto de perfil',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: theme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            PhotoSourceTile(
              icon: Icons.camera_alt_outlined,
              label: 'Tirar foto com a câmera',
              onTap: () => Navigator.pop(context, PhotoSource.camera),
            ),
            PhotoSourceTile(
              icon: Icons.photo_library_outlined,
              label: 'Escolher da galeria',
              onTap: () => Navigator.pop(context, PhotoSource.gallery),
            ),
            if (hasPhoto)
              PhotoSourceTile(
                icon: Icons.delete_outline,
                label: 'Remover foto atual',
                color: AppColors.error,
                onTap: () => Navigator.pop(context, PhotoSource.remove),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    ),
  );
}
