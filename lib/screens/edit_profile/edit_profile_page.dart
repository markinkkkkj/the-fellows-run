import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:the_fellows_run/screens/camera.dart';
import 'package:the_fellows_run/screens/edit_profile/widgets/photo_source_tile.dart';
import 'package:the_fellows_run/services/user_cache.dart';
import 'package:the_fellows_run/theme/app_colors.dart';

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
  String? _photoUrl;
  File? _newPhotoFile;
  String? _originalEmail;
  bool _isLoading = true;
  bool _isSaving = false;
  
  Future<void> _loadUserData() async {
    final data = await UserCache.load();
    _nameController.text = data['name'] ?? '';
    _emailController.text = data['email'] ?? '';
    _phoneController.text = _formatPhone(data['phone'] ?? '');
    _photoUrl = data['photoUrl'];
    _originalEmail = data['email'] ?? '';
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  String _formatPhone(String digits) {
    if (digits.length != 11) return digits;
    return '(${digits.substring(0, 2)}) ${digits.substring(2, 7)}-${digits.substring(7)}';
  }

  Future<String?> _askCurrentPassword() async {
    final controller = TextEditingController();
    final theme = Theme.of(context).colorScheme;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Confirme sua senha', style: TextStyle(color: theme.onSurface)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Pra mudar seu e-mail ou senha, precisamos confirmar quem você é.',
              style: TextStyle(color: theme.onSurface.withOpacity(0.7), fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              obscureText: true,
              autofocus: true,
              style: TextStyle(color: theme.onSurface),
              decoration: const InputDecoration(hintText: 'Senha atual'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancelar', style: TextStyle(color: theme.onSurface.withOpacity(0.6))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text('Confirmar', style: TextStyle(color: theme.primary)),
          ),
        ],
      ),
    );

    return result;
  }

  Future<void> _changePassword() async {
    final theme = Theme.of(context).colorScheme;
    final newPassController = TextEditingController();
    final confirmController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final shouldChange = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text('Nova senha', style: TextStyle(color: theme.onSurface)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: newPassController,
                obscureText: true,
                style: TextStyle(color: theme.onSurface),
                decoration: const InputDecoration(hintText: 'Nova senha'),
                validator: (v) {
                  if (v == null || v.length < 6) return 'Mínimo 6 caracteres';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: confirmController,
                obscureText: true,
                style: TextStyle(color: theme.onSurface),
                decoration: const InputDecoration(hintText: 'Confirmar nova senha'),
                validator: (v) {
                  if (v != newPassController.text) return 'As senhas não coincidem';
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar', style: TextStyle(color: theme.onSurface.withOpacity(0.6))),
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context, true);
              }
            },
            child: Text('Salvar', style: TextStyle(color: theme.primary)),
          ),
        ],
      ),
    );

    if (shouldChange != true) return;

    final currentPass = await _askCurrentPassword();
    if (currentPass == null || currentPass.isEmpty) return;

    final messenger = ScaffoldMessenger.of(context);

    try {
      final user = FirebaseAuth.instance.currentUser!;
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPass,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassController.text);

      messenger.showSnackBar(
        const SnackBar(content: Text('Senha alterada com sucesso!')),
      );
    } on FirebaseAuthException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Erro: ${e.message}')));
    }
  }

  Future<void> _pickPhoto() async {
    final theme = Theme.of(context).colorScheme;

    final source = await showModalBottomSheet<_PhotoSource>(
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
                onTap: () => Navigator.pop(context, _PhotoSource.camera),
              ),
              PhotoSourceTile(
                icon: Icons.photo_library_outlined,
                label: 'Escolher da galeria',
                onTap: () => Navigator.pop(context, _PhotoSource.gallery),
              ),
              if (_photoUrl != null || _newPhotoFile != null)
                PhotoSourceTile(
                  icon: Icons.delete_outline,
                  label: 'Remover foto atual',
                  color: AppColors.error,
                  onTap: () => Navigator.pop(context, _PhotoSource.remove),
                ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );

    if (source == null) return;

    switch (source) {
      case _PhotoSource.camera:
        await _pickFromCamera();
        break;
      case _PhotoSource.gallery:
        await _pickFromGallery();
        break;
      case _PhotoSource.remove:
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
      setState((){
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

  DecorationImage? _buildAvatarImage() {
    if (_newPhotoFile != null) {
      return DecorationImage(image: FileImage(_newPhotoFile!), fit: BoxFit.cover);
    }
    if (_photoUrl != null && _photoUrl!.isNotEmpty) {
      return DecorationImage(image: CachedNetworkImageProvider(_photoUrl!), fit: BoxFit.cover);
    }
    return null;
  }

  Widget? _buildAvatarPlaceholder(ColorScheme theme) {
    if (_newPhotoFile != null || (_photoUrl != null && _photoUrl!.isNotEmpty)) {
      return null;
    }
    final name = _nameController.text.trim();
    final initials = name.isEmpty
        ? '?'
        : name
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
    final user = FirebaseAuth.instance.currentUser!;
    final messenger = ScaffoldMessenger.of(context);

    try {
      String? photoUrl = _photoUrl;
      final ref =  FirebaseStorage.instance.ref().child('users/${user.uid}/profile.jpg');
      if (_newPhotoFile != null) {
        await ref.putFile(_newPhotoFile!);
        photoUrl = await ref.getDownloadURL();
      }
      if (photoUrl == null) {
        await ref.delete();
        await UserCache.clearPhoto();
      }
      final newEmail = _emailController.text;
      if (newEmail != _originalEmail) {
        final currentPass = await _askCurrentPassword();
        if (currentPass == null || currentPass.isEmpty) {
          _isSaving = false;
          return;
        }
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPass,
        );
        await user.reauthenticateWithCredential(credential);
        await user.verifyBeforeUpdateEmail(newEmail);
        messenger.showSnackBar(
          SnackBar(
            content: Text('Enviamos um e-mail de verificação. Confirme pelo link pra atualizar.'),
            duration: Duration(seconds: 4),  
          )
        );
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'name': _nameController.text.trim(),
        'email': newEmail,
        'phone': _phoneController.text.replaceAll(RegExp(r'\D'), ''),
        'photoUrl': photoUrl,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await UserCache.save(
        uid: user.uid,
        name: _nameController.text.trim(),
        email: newEmail,
        phone: _phoneController.text.replaceAll(RegExp(r'\D'), ''),
        photoUrl: photoUrl,
      );
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Perfil atualizado com sucesso!')),
        );
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text("Erro ao autenticar o usuário: ${error.message}"))
      );
    } catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text("Erro ao salvar os dados: $error"))
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
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: theme.primary,
                          shape: BoxShape.circle,
                          image: _buildAvatarImage(),
                        ),
                        child: _buildAvatarPlaceholder(theme),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _pickPhoto,
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
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: theme.onSurface),
                  decoration: const InputDecoration(hintText: 'Nome completo'),
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
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: theme.onSurface),
                  decoration: const InputDecoration(hintText: 'E-mail'),
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Informe seu e-mail';
                    final regex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$');
                    if (!regex.hasMatch(v.trim())) return 'E-mail inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                _label('WhatsApp'),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_phoneMask],
                  style: TextStyle(color: theme.onSurface),
                  decoration: const InputDecoration(hintText: 'WhatsApp'),
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

enum _PhotoSource { camera, gallery, remove }