import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/form_container.dart';
import '../widgets/nature_background.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_text_field.dart';
import 'login_screen.dart';
import '../poviders/AuthProvider.dart';
import 'package:provider/provider.dart';
import '../models/auth_models.dart';

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

  List<Curso> _cursos = [];
  int? _cursoSeleccionadoId;
  bool _isLoadingCursos = true;

  @override
  void initState() {
    super.initState();
    _cargarCursos();
  }

  Future<void> _cargarCursos() async {
    try {
      final authProvider = context.read<AuthProvider>();
      final cursosData = await authProvider.cargarCursos();
      setState(() {
        _cursos = cursosData!;
        _isLoadingCursos = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingCursos = false;
      });
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _contrasennaController.dispose();
    _confirmarContrasennaController.dispose();
    _documentoController.dispose();
    super.dispose();
  }

  void _limpiarFormulario() {
    _nombreController.clear();
    _documentoController.clear();
    _contrasennaController.clear();
    _confirmarContrasennaController.clear();

    setState(() {
      _cursoSeleccionadoId = null;
    });
  }

  void _onRegister() async {
    if (_cursoSeleccionadoId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor selecciona un curso',
            style: AppTheme.pixelBody(size: 8, color: Colors.white),
          ),
          backgroundColor: AppColors.softPinkDark,
        ),
      );
      return;
    }

    if (_contrasennaController.text != _confirmarContrasennaController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Las contrasennas no coinciden',
            style: AppTheme.pixelBody(size: 8, color: Colors.white),
          ),
          backgroundColor: AppColors.softPinkDark,
        ),
      );
      return;
    }

    final authProvider = context.read<AuthProvider>();
    final bool success = await authProvider.registrarUsuario(
      documento: _documentoController.text,
      nombre: _nombreController.text,
      cursoId: _cursoSeleccionadoId!,
      contrasenna: _contrasennaController.text,
    );
    if (!mounted) return;

    if (success) {
      _limpiarFormulario();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Cuenta creada ',
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'curso',
                          style: AppTheme.pixelBody(
                            size: 8,
                            color: AppColors.oliveGreen,
                          ),
                        ),
                        const SizedBox(height: 6),
                        _isLoadingCursos
                            ? const CircularProgressIndicator()
                            : Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(4),
                                  color: Colors.white,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<int>(
                                    value: _cursoSeleccionadoId,
                                    isExpanded: true,
                                    hint: const Text('Selecciona tu curso'),
                                    items: _cursos.map((curso) {
                                      return DropdownMenuItem<int>(
                                        value: (curso.idCurso),
                                        child: Text(
                                          curso.nombre,
                                          style: AppTheme.pixelBody(
                                            size: 8,
                                            color: AppColors.oliveGreen,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (int? value) {
                                      setState(() {
                                        _cursoSeleccionadoId = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    PixelTextField(
                      label: 'Contrasena',
                      controller: _contrasennaController,
                      hint: '********',
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    PixelTextField(
                      label: 'Confirmar Contrasena',
                      controller: _confirmarContrasennaController,
                      hint: '********',
                      obscureText: true,
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
