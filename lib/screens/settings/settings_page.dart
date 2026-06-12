import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_fellows_run/models/user.dart';

import 'package:the_fellows_run/screens/edit_profile/edit_profile_page.dart';
import 'package:the_fellows_run/services/user_cache.dart';
import 'package:the_fellows_run/theme/app_colors.dart';

import 'widgets/settings_tiles.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  AppUser? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
    final data = await UserCache.load();
      if (mounted) {
        setState(() => _user = AppUser.fromCache(data));
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar dados: $error')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signOut() async {
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    try {
      await FirebaseAuth.instance.signOut();
      await UserCache.clear();
      // O StreamBuilder de authStateChanges (app.dart) já troca a raiz pra
      // Login; aqui só desempilhamos tudo até ela ficar visível.
      navigator.popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (error) {
      messenger.showSnackBar(
        SnackBar(content: Text(error.message ?? 'Erro ao sair')),
      );
    }
  }

  Future<void> _openEditProfile() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditProfile()),
    );
    await _loadUserData();
  }

  String _getInitials() {
    final name = _user?.name.trim() ?? '';
    if (name.isEmpty) return '?';
    return name
        .split(' ')
        .take(2)
        .map((p) => p.isNotEmpty ? p[0] : '')
        .join()
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurações',
          style: TextStyle(
            color: theme.onPrimary,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: theme.primary,
        iconTheme: IconThemeData(color: theme.onPrimary),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                // ─── CARD DO PERFIL ─────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: theme.primary,
                            shape: BoxShape.circle,
                            image: (_user!.photoUrl != null && _user!.photoUrl!.isNotEmpty)
                                ? DecorationImage(
                                    image: CachedNetworkImageProvider(_user!.photoUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (_user!.photoUrl == null || _user!.photoUrl!.isEmpty)
                              ? Center(
                                  child: Text(
                                    _getInitials(),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                      color: theme.onPrimary,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _user?.name ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _user?.email ?? '',
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.mutedFg,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ─── SEÇÃO: CONTA ───────────────────────────
                const SectionTitle('Conta'),
                SettingsTile(
                  icon: Icons.person_outline,
                  label: 'Editar perfil',
                  onTap: _openEditProfile,
                ),
                SettingsTile(
                  icon: Icons.notifications_outlined,
                  label: 'Notificações',
                  onTap: () {},
                ),

                const SizedBox(height: 24),

                // ─── SEÇÃO: SOBRE ───────────────────────────
                const SectionTitle('Sobre'),
                SettingsTile(
                  icon: Icons.info_outline,
                  label: 'Sobre o app',
                  onTap: () {},
                ),
                SettingsTile(
                  icon: Icons.help_outline,
                  label: 'Ajuda',
                  onTap: () {},
                ),

                const SizedBox(height: 32),

                // ─── BOTÃO SAIR ─────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OutlinedButton.icon(
                    onPressed: _signOut,
                    icon: const Icon(Icons.logout, color: AppColors.error),
                    label: const Text(
                      'Sair da conta',
                      style: TextStyle(
                        color: AppColors.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(54),
                      side: const BorderSide(
                        color: AppColors.error,
                        width: 1.5,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
