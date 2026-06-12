import 'package:flutter/material.dart';

/// Campo de senha com botão de mostrar/esconder. O estado do "obscure" é
/// interno, então cada campo gerencia o próprio toggle.
class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;

  const PasswordField({
    super.key,
    required this.controller,
    this.hintText = 'Senha',
    this.textInputAction,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscure,
      textInputAction: widget.textInputAction,
      style: TextStyle(color: theme.onSurface),
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      validator: widget.validator,
    );
  }
}
