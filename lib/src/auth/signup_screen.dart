import 'package:cubicador_pro/src/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:cubicador_pro/src/projects/project_list_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await _authService.createUserWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        );
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProjectListScreen()),
          );
        }
      } on AuthException catch (e) {
        if (mounted) {
          final l10n = AppLocalizations.of(context)!;
          String errorMessage = l10n.signupError;
          switch (e.code) {
            case 'email-already-in-use':
              errorMessage = l10n.emailInUse;
              break;
            case 'weak-password':
              errorMessage = l10n.weakPassword;
              break;
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.register),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: l10n.email),
                validator: (value) => value!.isEmpty ? l10n.fieldRequired : null,
                enabled: !_isLoading,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: l10n.password),
                obscureText: true,
                validator: (value) => value!.isEmpty ? l10n.fieldRequired : null,
                enabled: !_isLoading,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                child: _isLoading
                    ? const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                    : Text(l10n.register),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
