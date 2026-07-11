import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/form_container.dart';
import '../widgets/nature_background.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_text_field.dart';
import 'login_screen.dart';
import '../services/AuthService.dart';
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombreController = TextEditingController();
  final _contrasennaController = TextEditingController();
  final _confirmarContrasennaController = TextEditingController();
  final _documentoController = TextEditingController();
  final _rolController = TextEditingController();
  final _cursoController = TextEditingController();
  final _puntosController = TextEditingController();

  @override
  void dispose() {
    _nombreController.dispose();
    _contrasennaController.dispose();
    _confirmarContrasennaController.dispose();
    _documentoController.dispose();
    _rolController.dispose();
    _cursoController.dispose();
    _puntosController.dispose();
    super.dispose();
  }

  void _onRegister() async  {
    final authService = AuthService();
    final bool success = await authService.registrarUsuario(
      _documentoController.text,
      _nombreController.text,
      _rolController.text,
      int.parse(_cursoController.text),
      _contrasennaController.text,
      int.parse(_puntosController.text),
      );

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cuenta creada para ${_documentoController.text}',
            style: AppTheme.pixelBody(size: 8, color: Colors.white),
          ),
          backgroundColor: AppColors.oliveGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al crear cuenta',
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
                  title: 'Crear Cuenta',
                  subtitle: 'UNETE A LA AVENTURA NATURAL',
                  children: [
                    PixelTextField(
                      label: 'Nombre completo',
                      controller: _nombreController,
                      hint: 'Tu nombre',
                    ),
                    const SizedBox(height: 14),
                    PixelTextField(
                      label: 'Documento',
                      controller: _documentoController,
                      hint: '1234567890',
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    PixelTextField(
                      label: 'Nombre',
                      controller: _nombreController,
                      hint: 'Tu nombre',
                    ),
                    const SizedBox(height: 24),
                    PixelButton(
                      label: 'REGISTRARSE',
                      width: double.infinity,
                      onPressed: _onRegister,
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Ya tienes cuenta? Ingresar',
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
