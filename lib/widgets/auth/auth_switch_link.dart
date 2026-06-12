import 'package:flutter/material.dart';

/// Rodapé que alterna entre login e cadastro: um texto de pergunta seguido de
/// um link clicável (ex.: "Não tem conta? Cadastre-se").
class AuthSwitchLink extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback onTap;

  const AuthSwitchLink({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            question,
            style: TextStyle(color: theme.onSurface.withOpacity(0.6)),
          ),
          GestureDetector(
            onTap: onTap,
            child: Text(
              action,
              style: TextStyle(
                color: theme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
