import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

/// Avatar editável do perfil: mostra a foto nova, a atual ou as iniciais do
/// nome, com um botão de câmera sobreposto. [onTap] é disparado no botão.
class ProfileAvatarPicker extends StatelessWidget {
  final File? newPhotoFile;
  final String? photoUrl;
  final String name;
  final VoidCallback onTap;

  const ProfileAvatarPicker({
    super.key,
    required this.newPhotoFile,
    required this.photoUrl,
    required this.name,
    required this.onTap,
  });

  DecorationImage? _buildImage() {
    if (newPhotoFile != null) {
      return DecorationImage(image: FileImage(newPhotoFile!), fit: BoxFit.cover);
    }
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return DecorationImage(image: CachedNetworkImageProvider(photoUrl!), fit: BoxFit.cover);
    }
    return null;
  }

  Widget? _buildPlaceholder(ColorScheme theme) {
    if (newPhotoFile != null || (photoUrl != null && photoUrl!.isNotEmpty)) {
      return null;
    }
    final trimmed = name.trim();
    final initials = trimmed.isEmpty
        ? '?'
        : trimmed
            .split(' ')
            .take(2)
            .map((p) => p.isNotEmpty ? p[0] : '')
            .join()
            .toUpperCase();
    return Center(
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w800,
          color: theme.onPrimary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Stack(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: theme.primary,
            shape: BoxShape.circle,
            image: _buildImage(),
          ),
          child: _buildPlaceholder(theme),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.primary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.darkBg,
                  width: 3,
                ),
              ),
              child: Icon(
                Icons.camera_alt,
                color: theme.onPrimary,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
