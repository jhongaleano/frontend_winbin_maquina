import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/form_container.dart';
import '../widgets/nature_background.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_text_field.dart';
import 'register_screen.dart';
import '../services/AuthService.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _documentoController = TextEditingController();
  final _contrasennaController = TextEditingController();
  @override
  void dispose() {
    _documentoController.dispose();
    _contrasennaController.dispose();
    super.dispose();
  }

  void _onLogin() async {
    final authService = AuthService();
    final bool success = await authService.login(
      _documentoController.text,
      _contrasennaController.text,
    );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Bienvenido, ${_documentoController.text}',
            style: AppTheme.pixelBody(size: 8, color: Colors.white),
          ),
          backgroundColor: AppColors.oliveGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al iniciar sesión',
            style: AppTheme.pixelBody(size: 8, color: Colors.white),
          ),
          backgroundColor: AppColors.softPinkDark,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NatureBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(
              children: [
                FormContainer(
                  title: 'Iniciar Sesion',
                  subtitle: 'TEJIENDO EXPERIENCIAS FUERA DEL AULA',
                  children: [
                    PixelTextField(
                      label: 'Documento',
                      controller: _documentoController,
                      hint: 'Tu documento de identidad',
                    ),
                    const SizedBox(height: 16),
                    PixelTextField(
                      label: 'Contrasena',
                      controller: _contrasennaController,
                      obscureText: true,
                      hint: '********',
                    ),
                    const SizedBox(height: 24),
                    PixelButton(
                      label: 'INGRESAR',
                      width: double.infinity,
                      onPressed: _onLogin,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'No tienes cuenta? Crear una',
                        textAlign: TextAlign.center,
                        style: AppTheme.pixelBody(
                          size: 7,
                          color: AppColors.oliveGreen,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 120),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
