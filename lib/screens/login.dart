import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:the_fellows_run/screens/signup.dart';
import '../services/user_cache.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

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
    final userData = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    UserCache.save(
      uid: uid!,
      name: userData['name'] ?? '', 
      email: userData['email'] ?? '', 
      phone: userData['phone'] ?? '',
      photoUrl: userData['photoUrl'],
    );
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

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: const InputDecoration(hintText: 'E-mail'),
              ),
              const SizedBox(height: 14),

              // Campo senha
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                decoration: InputDecoration(
                  hintText: 'Senha',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      //color: AppColors.mutedFg,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
              ),
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
              ElevatedButton(
                onPressed: _isLoading ? null : () async {
                  _login();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Entrar'),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
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
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Não tem conta? ',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6)),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Signup())
                        );
                      },
                      child: Text(
                        'Cadastre-se',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
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
    );
  }
}