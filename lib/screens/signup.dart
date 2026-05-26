import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.user!.uid)
            .set({
              'name': _nameController.text,
              'email': _emailController.text,
              'phone': _phoneController.text.replaceAll(RegExp(r'\D'), ''),
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
                TextFormField(
                  controller: _nameController,
                  style: TextStyle(color: theme.onSurface),
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(hintText: 'Nome completo'),
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
                TextFormField(
                  controller: _emailController,
                  style: TextStyle(color: theme.onSurface),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(hintText: 'E-mail'),
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
                TextFormField(
                  controller: _phoneController,
                  style: TextStyle(color: theme.onSurface),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_phoneMask],
                  decoration: const InputDecoration(hintText: 'WhatsApp'),
                  validator: (value) {
                    final apenasNumeros = value?.replaceAll(RegExp(r'\D'), '') ?? '';
                    if (apenasNumeros.isEmpty) {
                      return 'Informe seu WhatsApp';
                    }
                    if (apenasNumeros.length != 11) {
                      return 'Número inválido. Ex: (11) 98765-4321';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 14),

                // Senha
                TextFormField(
                  controller: _passwordController,
                  style: TextStyle(color: theme.onSurface),
                  obscureText: _obscurePassword,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        //color: theme.mutedFg,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
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
                TextFormField(
                  controller: _confirmPasswordController,
                  style: TextStyle(color: theme.onSurface),
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    hintText: 'Confirmar senha',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        //color: theme.mutedFg,
                      ),
                      onPressed: () {
                        setState(() =>
                            _obscureConfirmPassword = !_obscureConfirmPassword);
                      },
                    ),
                  ),
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
                ElevatedButton(
                  onPressed: _createAccount,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Continuar'),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Link pra voltar pro login
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Já tem conta?  ',
                        style: TextStyle(color: theme.onSurface.withOpacity(0.6)),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Entrar',
                          style: TextStyle(
                            color: theme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
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