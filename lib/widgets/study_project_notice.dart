import 'package:flutter/material.dart';

import 'package:the_fellows_run/theme/app_colors.dart';

/// Textos do aviso de projeto de estudo, usados no card e na tela "Sobre o app".
class StudyProjectText {
  static const title = 'Projeto de estudo';

  static const summary =
      'Este app foi feito para estudar Flutter e não está em desenvolvimento '
      'ativo: fica no ar só para demonstração. Você pode se cadastrar com '
      'dados fictícios.';

  static const details = [
    'O The Fellows Run foi criado como projeto de estudo de Flutter para uma '
        'avaliação da faculdade. Ele não está em desenvolvimento ativo e fica '
        'no ar só para demonstração.',
    'Para testar, você pode se cadastrar com nome, e-mail e telefone '
        'fictícios. Com um e-mail fictício não dá para recuperar a senha.',
    'Se preferir usar dados reais, eles ficam protegidos por regras de acesso '
        'no Firebase: seu e-mail e seu telefone só podem ser lidos por você. '
        'Seu nome e sua foto aparecem para quem estiver logado, nas corridas '
        'em que você se inscrever.',
  ];
}

/// Card de aviso exibido no login e no cadastro.
class StudyProjectNotice extends StatelessWidget {
  const StudyProjectNotice({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.alert.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.alert.withOpacity(0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.alert, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  StudyProjectText.title,
                  style: TextStyle(
                    color: AppColors.alert,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  StudyProjectText.summary,
                  style: TextStyle(
                    fontSize: 12.5,
                    height: 1.4,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Diálogo "Sobre o app", com o aviso completo.
Future<void> showAboutStudyProject(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text(StudyProjectText.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final paragraph in StudyProjectText.details)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(paragraph, style: const TextStyle(height: 1.4)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Entendi'),
        ),
      ],
    ),
  );
}
