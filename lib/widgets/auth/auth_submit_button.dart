import 'package:flutter/material.dart';

/// Botão primário das telas de autenticação: rótulo + seta. Passe [onPressed]
/// nulo para desabilitar (ex.: durante o loading).
class AuthSubmitButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const AuthSubmitButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward, size: 18),
        ],
      ),
    );
  }
}
