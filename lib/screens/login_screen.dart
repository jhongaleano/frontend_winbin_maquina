import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/form_container.dart';
import '../widgets/nature_background.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_text_field.dart';
import 'register_screen.dart';
import '../poviders/AuthProvider.dart';
import 'CamaraScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final _documentoController = TextEditingController();
  final _contrasennaController = TextEditingController();

  bool _isLoading = false;
  @override
  void dispose() {
    _documentoController.dispose();
    _contrasennaController.dispose();
    super.dispose();
  }

  Future<void> _onLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _isLoading = true;
    });
    try {
      final authProvider = context.read<AuthProvider>();

      final bool exito = await authProvider
          .iniciarSesion(
            _documentoController.text.trim(),
            _contrasennaController.text.trim(),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Tiempo de espera agotado');
            },
          );

      if (!mounted) return;

      if (exito) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Bienvenido, ${_documentoController.text}',
              style: AppTheme.pixelBody(size: 8, color: Colors.white),
            ),
            backgroundColor: AppColors.oliveGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (_) => const CameraScreen()),
        );
      } else {
        _mostrarError('Credenciales incorrectas');
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarError('Error de conexión: Verifica el estado del servidor');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _mostrarError(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: AppTheme.pixelBody(size: 8, color: Colors.white),
        ),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NatureBackground(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FormContainer(
                        title: 'Iniciar Sesion',
                        subtitle: 'TEJIENDO EXPERIENCIAS FUERA DEL AULA',
                        children: [
                          PixelTextField(
                            label: 'Documento',
                        
                            controller: _documentoController,
                            hint: 'Tu documento de identidad',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Por favor ingresa tu documento';
                              }
                              if (value.trim().length < 4) {
                                return 'El documento debe tener al menos 4 digitos';
                              }
                              if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                                return 'Ingresa solo números';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          PixelTextField(
                            label: 'Contrasena',
                            controller: _contrasennaController,
                            obscureText: true,
                            hint: '********',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Por favor ingresa tu contraseña';
                              }
                              if (value.trim().length < 6) {
                                return 'La contraseña debe tener al menos 6 caracteres';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 50,
                            child: _isLoading 
                            ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.green,
                              ),
                            )
                            :PixelButton(
                              label: 'INGRESAR',
                              width: double.infinity,
                              onPressed: _onLogin,
                            ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: _isLoading 
                            ? null 
                            : () {
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
          ),
        ),
      ),
    );
  }
}
