import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_fellows_run/models/user.dart';
import 'package:the_fellows_run/screens/signup.dart';
import 'package:the_fellows_run/widgets/app_text_field.dart';
import 'package:the_fellows_run/widgets/auth/auth_submit_button.dart';
import 'package:the_fellows_run/widgets/auth/auth_switch_link.dart';
import 'package:the_fellows_run/widgets/auth/password_field.dart';
import '../services/user_cache.dart';
import 'home/home_page.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  void _login() async {
    _isLoading = true;
    String email = _emailController.text;
    String password = _passwordController.text;
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      _loadData(user.user!.uid);
      _isLoading = false;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage())
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$error"))
      );
      _isLoading = false;
    }
  }

  void _loadData(String uid) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final data = doc.data();
    if (data == null) return;
    final user = AppUser.fromFirestore(uid!, data);
    UserCache.save(user.toCacheMap());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),

              // Logo
              Center(
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.flash_on,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 36,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Nome do app
              Center(
                child: Text(
                  'THE FELLOWS RUN',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Center(
                child: Text(
                  'cada quilômetro importa.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: 48),

              // Título
              Text(
                'Bem-vindo de volta',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 6),
              Text(
                'Entre para continuar sua jornada.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 28),

              AppTextField(
                controller: _emailController,
                hintText: 'E-mail',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),

              // Campo senha
              PasswordField(controller: _passwordController),
              const SizedBox(height: 12),

              // Esqueci a senha
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'Esqueci a senha',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Botão Entrar
              AuthSubmitButton(
                label: 'Entrar',
                onPressed: _isLoading ? null : _login,
              ),
              const SizedBox(height: 24),

              // Divider "ou"
              Row(
                children: [
                  Expanded(child: Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'ou',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
                    ),
                  ),
                  Expanded(child: Divider(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.1))),
                ],
              ),
              const SizedBox(height: 20),

              // Cadastre-se
              AuthSwitchLink(
                question: 'Não tem conta? ',
                action: 'Cadastre-se',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Signup()),
                  );
                },
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}