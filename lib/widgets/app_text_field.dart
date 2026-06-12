import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo de texto padrão do app (e-mail, nome, WhatsApp...). Já aplica o estilo
/// padrão; o resto vem por parâmetro.
class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      style: TextStyle(color: theme.onSurface),
      decoration: InputDecoration(hintText: hintText),
      validator: validator,
    );
  }
}
