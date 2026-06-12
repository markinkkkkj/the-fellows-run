import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:the_fellows_run/models/user.dart';
import 'package:the_fellows_run/widgets/app_text_field.dart';
import 'package:the_fellows_run/widgets/auth/auth_submit_button.dart';
import 'package:the_fellows_run/widgets/auth/auth_switch_link.dart';
import 'package:the_fellows_run/widgets/auth/password_field.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _acceptedTerms = false;
  final _phoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {'#': RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  void _createAccount() async {
    if (_formKey.currentState!.validate()) {
      final messanger = ScaffoldMessenger.of(context);
      final navigator = Navigator.of(context);
      UserCredential? user;
      try {
        user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text, 
          password: _passwordController.text
        );
        final profile = AppUser(
          uid: user.user!.uid,
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text.replaceAll(RegExp(r'\D'), ''),
        );
        await FirebaseFirestore.instance
            .collection("users")
            .doc(profile.uid)
            .set({
              ...profile.toFirestore(),
              'createdAt': FieldValue.serverTimestamp(),
            });
        await FirebaseAuth.instance.signOut();
        navigator.pop();
      } on FirebaseAuthException catch (error) {
        messanger.showSnackBar(
          SnackBar(content: Text(error.message ?? "Erro ao cadastrar usuário"))
        );
        return;
      } on FirebaseException catch (error) {
        await user!.user!.delete();
        messanger.showSnackBar(
          SnackBar(content: Text(error.message ?? "Erro ao cadastrar usuário no banco"))
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme theme = Theme.of(context).colorScheme;
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),

                // Botão voltar (canto esquerdo)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(height: 8),

                // Logo
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: theme.primary,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: theme.primary.withOpacity(0.4),
                          blurRadius: 24,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.flash_on,
                      color: theme.onPrimary,
                      size: 32,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Nome do app
                Center(
                  child: Text(
                    'THE FELLOWS RUN',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: theme.onSurface,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    'Comece sua jornada hoje.',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Título + indicador de etapa
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Criar conta',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Preencha os dados para continuar',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 24),

                // Nome completo
                AppTextField(
                  controller: _nameController,
                  hintText: 'Nome completo',
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu nome completo';
                    }
                    if (value.trim().split(' ').length < 2) {
                      return 'Informe nome e sobrenome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // E-mail
                AppTextField(
                  controller: _emailController,
                  hintText: 'E-mail',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Informe seu e-mail';
                    }
                    // validação simples de e-mail
                    final regex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\-\.]+$');
                    if (!regex.hasMatch(value.trim())) {
                      return 'E-mail inválido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Número de WhatsApp
                AppTextField(
                  controller: _phoneController,
                  hintText: 'WhatsApp',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_phoneMask],
                  validator: (value) {
                    final digitsOnly = value?.replaceAll(RegExp(r'\D'), '') ?? '';
                    if (digitsOnly.isEmpty) {
                      return 'Informe seu WhatsApp';
                    }
                    if (digitsOnly.length != 11) {
                      return 'Número inválido. Ex: (11) 98765-4321';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Senha
                PasswordField(
                  controller: _passwordController,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Informe uma senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Confirmar senha
                PasswordField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirmar senha',
                  textInputAction: TextInputAction.done,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirme sua senha';
                    }
                    if (value != _passwordController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Checkbox dos termos
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _acceptedTerms,
                        onChanged: (value) {
                          setState(() => _acceptedTerms = value ?? false);
                        },
                        activeColor: theme.primary,
                        checkColor: theme.onSurface,
                        side: BorderSide(
                          color: theme.onSurface.withOpacity(0.3),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => _acceptedTerms = !_acceptedTerms);
                        },
                        child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.onSurface.withOpacity(0.7),
                            ),
                            children: [
                              TextSpan(text: 'Li e concordo com os '),
                              TextSpan(
                                text: 'Termos de Uso',
                                style: TextStyle(
                                  color: theme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(text: ' e a '),
                              TextSpan(
                                text: 'Política de Privacidade',
                                style: TextStyle(
                                  color: theme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Botão Continuar
                AuthSubmitButton(
                  label: 'Continuar',
                  onPressed: _createAccount,
                ),
                const SizedBox(height: 16),

                // Link pra voltar pro login
                AuthSwitchLink(
                  question: 'Já tem conta?  ',
                  action: 'Entrar',
                  onTap: () => Navigator.pop(context),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}