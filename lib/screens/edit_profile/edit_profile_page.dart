import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:the_fellows_run/models/user.dart';

import 'package:the_fellows_run/screens/camera.dart';
import 'package:the_fellows_run/screens/edit_profile/widgets/password_dialogs.dart';
import 'package:the_fellows_run/screens/edit_profile/widgets/photo_source_sheet.dart';
import 'package:the_fellows_run/screens/edit_profile/widgets/profile_avatar_picker.dart';
import 'package:the_fellows_run/services/registration_repository.dart';
import 'package:the_fellows_run/services/user_repository.dart';
import 'package:the_fellows_run/theme/app_colors.dart';
import 'package:the_fellows_run/widgets/app_text_field.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );
  final _repository = UserRepository();
  final _registrationRepo = RegistrationRepository();

  AppUser? _user;
  String? _photoUrl;
  File? _newPhotoFile;
  bool _isLoading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final user = await _repository.loadFromCache();
    _nameController.text = user.name;
    _emailController.text = user.email;
    _phoneController.text = _formatPhone(user.phone);
    _user = user;
    _photoUrl = user.photoUrl;
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  String _formatPhone(String digits) {
    if (digits.length != 11) return digits;
    return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}';
  }

  Future<void> _changePassword() async {
    final newPass = await showNewPasswordDialog(context);
    if (newPass == null) return;
    if (!mounted) return;

    final currentPass = await showConfirmPasswordDialog(context);
    if (currentPass == null || currentPass.isEmpty) return;
    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    try {
      await _repository.changePassword(currentPass, newPass);
      messenger.showSnackBar(
        const SnackBar(content: Text('Senha alterada com sucesso!')),
      );
    } on FirebaseAuthException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Erro: ${e.message}')));
    }
  }

  Future<void> _pickPhoto() async {
    final source = await showPhotoSourceSheet(
      context,
      hasPhoto: _photoUrl != null || _newPhotoFile != null,
    );
    if (source == null) return;

    switch (source) {
      case PhotoSource.camera:
        await _pickFromCamera();
        break;
      case PhotoSource.gallery:
        await _pickFromGallery();
        break;
      case PhotoSource.remove:
        setState(() {
          _newPhotoFile = null;
          _photoUrl = null;
        });
        break;
    }
  }

  Future<void> _pickFromCamera() async {
    final result = await Navigator.push<XFile>(
      context,
      MaterialPageRoute(builder: (context) => Camera()),
    );

    if (result != null) {
      setState(() {
        _newPhotoFile = File(result.path);
      });
    }
  }

  Future<void> _pickFromGallery() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 80,
    );
    if (picked != null) {
      setState(() {
        _newPhotoFile = File(picked.path);
      });
    }
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, left: 4),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.mutedFg,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isSaving = true;
    });
    final messenger = ScaffoldMessenger.of(context);

    try {
      final photoUrl = await _repository.resolveProfilePhoto(
        newPhotoFile: _newPhotoFile,
        currentPhotoUrl: _photoUrl,
      );

      final newEmail = _emailController.text;
      if (newEmail != _user!.email) {
        if (!mounted) return;
        final currentPass = await showConfirmPasswordDialog(context);
        if (currentPass == null || currentPass.isEmpty) {
          return;
        }
        await _repository.updateEmail(newEmail, currentPass);
        messenger.showSnackBar(
          const SnackBar(
            content: Text('Enviamos um e-mail de verificação. Confirme pelo link pra atualizar.'),
            duration: Duration(seconds: 4),
          ),
        );
      }

      final updated = AppUser(
        uid: _user!.uid,
        name: _nameController.text.trim(),
        email: newEmail,
        phone: _phoneController.text.replaceAll(RegExp(r'\D'), ''),
        photoUrl: photoUrl,
        role: _user!.role,
      );
      await _repository.saveProfile(updated);
      // Propaga nome/foto pras inscrições (dados denormalizados).
      await _registrationRepo.syncProfile(
        name: updated.name,
        photoUrl: updated.photoUrl,
      );

      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!')),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text("Erro ao autenticar o usuário: ${error.message}")),
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text("Erro ao salvar os dados: $error")),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            'Editar perfil',
            style: TextStyle(color: theme.onPrimary, fontWeight: FontWeight.w700),
          ),
          backgroundColor: theme.primary,
          iconTheme: IconThemeData(color: theme.onPrimary),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar perfil',
          style: TextStyle(color: theme.onPrimary, fontWeight: FontWeight.w700),
        ),
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(color: theme.onPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ─── FOTO ─────────────────────────────────────
                Center(
                  child: ProfileAvatarPicker(
                    newPhotoFile: _newPhotoFile,
                    photoUrl: _photoUrl,
                    name: _nameController.text,
                    onTap: _pickPhoto,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    onPressed: _pickPhoto,
                    child: Text(
                      'Alterar foto',
                      style: TextStyle(
                        color: theme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // ─── CAMPOS ───────────────────────────────────
                _label('Nome completo'),
                AppTextField(
                  controller: _nameController,
                  hintText: 'Nome completo',
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Informe seu nome';
                    if (v.trim().split(' ').length < 2) {
                      return 'Informe nome e sobrenome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _label('E-mail'),
                AppTextField(
                  controller: _emailController,
                  hintText: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Informe seu e-mail';
                    final regex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$');
                    if (!regex.hasMatch(v.trim())) return 'E-mail inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _label('WhatsApp'),
                AppTextField(
                  controller: _phoneController,
                  hintText: 'WhatsApp',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_phoneMask],
                  validator: (v) {
                    final digits = v?.replaceAll(RegExp(r'\D'), '') ?? '';
                    if (digits.isEmpty) return 'Informe seu WhatsApp';
                    if (digits.length != 11) return 'Número inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                OutlinedButton.icon(
                  onPressed: _changePassword,
                  icon: Icon(Icons.lock_outline, color: theme.primary),
                  label: Text(
                    'Alterar senha',
                    style: TextStyle(
                      color: theme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(54),
                    side: BorderSide(color: theme.primary, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  child: _isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Colors.black,
                          ),
                        )
                      : const Text('Salvar alterações'),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
