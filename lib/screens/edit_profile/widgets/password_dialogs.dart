import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

/// Pede a senha atual do usuário (reautenticação). Retorna a senha digitada
/// ou null se cancelado.
Future<String?> showConfirmPasswordDialog(BuildContext context) {
  final controller = TextEditingController();
  final theme = Theme.of(context).colorScheme;

  return showDialog<String>(
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
}

/// Pede e valida a nova senha (com confirmação). Retorna a nova senha digitada
/// ou null se cancelado.
Future<String?> showNewPasswordDialog(BuildContext context) {
  final theme = Theme.of(context).colorScheme;
  final newPassController = TextEditingController();
  final confirmController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  return showDialog<String>(
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
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar', style: TextStyle(color: theme.onSurface.withOpacity(0.6))),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Navigator.pop(context, newPassController.text);
            }
          },
          child: Text('Salvar', style: TextStyle(color: theme.primary)),
        ),
      ],
    ),
  );
}
