import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

/// Pede um valor em km. Retorna o valor digitado ou null se cancelado.
/// [initial] pré-preenche o campo e [title] rotula o diálogo.
Future<num?> showGoalDialog(
  BuildContext context,
  num initial, {
  String title = 'Sua meta (km)',
}) {
  final controller = TextEditingController(
    text: initial % 1 == 0 ? initial.toInt().toString() : initial.toString(),
  );
  final formKey = GlobalKey<FormState>();
  final theme = Theme.of(context).colorScheme;

  return showDialog<num>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.card,
      title: Text(title, style: TextStyle(color: theme.onSurface)),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
          ],
          style: TextStyle(color: theme.onSurface),
          decoration: const InputDecoration(hintText: 'Ex: 5'),
          validator: (v) {
            final text = (v ?? '').trim();
            if (text.isEmpty) return null; // vazio é permitido (vira 0)
            final value = num.tryParse(text.replaceAll(',', '.'));
            if (value == null || value < 0) return 'Valor inválido';
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancelar',
              style: TextStyle(color: theme.onSurface.withOpacity(0.6))),
        ),
        TextButton(
          onPressed: () {
            if (formKey.currentState!.validate()) {
              final text = controller.text.trim();
              final value =
                  text.isEmpty ? 0 : num.parse(text.replaceAll(',', '.'));
              Navigator.pop(context, value);
            }
          },
          child: Text('Salvar', style: TextStyle(color: theme.primary)),
        ),
      ],
    ),
  );
}
