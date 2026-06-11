import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:the_fellows_run/screens/edit_profile/edit_profile_page.dart';
import 'package:the_fellows_run/screens/login.dart';
import 'package:the_fellows_run/services/user_cache.dart';
import 'package:the_fellows_run/theme/app_colors.dart';

import 'widgets/settings_tiles.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String? _name;
  String? _email;
  String? _photoUrl;
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
        setState(() {
          _name = data['name'] ?? 'Sem nome';
          _email = data['email'] ?? '';
          _photoUrl = data['photoUrl'];
        });
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
      UserCache.clear();
      navigator.pushReplacement(
        MaterialPageRoute(builder: (context) => Login())
      );
      navigator.pop();
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
    final name = _name?.trim() ?? '';
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
                            image: (_photoUrl != null && _photoUrl!.isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(_photoUrl!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: (_photoUrl == null || _photoUrl!.isEmpty)
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
                                _name ?? '',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _email ?? '',
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
