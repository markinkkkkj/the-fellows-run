import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

/// Pede a meta pessoal (km) do usuário. Retorna o valor digitado ou null se
/// cancelado. [initial] pré-preenche o campo.
Future<num?> showGoalDialog(BuildContext context, num initial) {
  final controller = TextEditingController(
    text: initial % 1 == 0 ? initial.toInt().toString() : initial.toString(),
  );
  final formKey = GlobalKey<FormState>();
  final theme = Theme.of(context).colorScheme;

  return showDialog<num>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColors.card,
      title: Text('Sua meta (km)', style: TextStyle(color: theme.onSurface)),
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
            final value = num.tryParse((v ?? '').replaceAll(',', '.'));
            if (value == null || value <= 0) return 'Meta inválida';
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
              Navigator.pop(
                context,
                num.parse(controller.text.replaceAll(',', '.')),
              );
            }
          },
          child: Text('Salvar', style: TextStyle(color: theme.primary)),
        ),
      ],
    ),
  );
}
