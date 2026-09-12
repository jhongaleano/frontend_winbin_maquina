import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/form_container.dart';
import '../widgets/nature_background.dart';
import '../widgets/pixel_button.dart';
import '../widgets/pixel_text_field.dart';
import 'login_screen.dart';
import '../poviders/AuthProvider.dart';
import '../models/auth_models.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nombreController = TextEditingController();
  final _contrasennaController = TextEditingController();
  final _confirmarContrasennaController = TextEditingController();
  final _documentoController = TextEditingController();

  List<Curso> _cursos = [];
  int? _cursoSeleccionadoId;

  bool _isLoadingCursos = true;
  bool _isRegistering = false;

  @override
  void initState() {
    super.initState();
    _cargarCursos();
  }

  Future<void> _cargarCursos() async {
    try {
      final authProvider = context.read<AuthProvider>();
      final cursosData = await authProvider.cargarCursos();
      if (!mounted) return;
      setState(() {
        _cursos = cursosData!;
        _isLoadingCursos = false;
      });
    } catch (e) {
      if (!mounted) return;
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_cursoSeleccionadoId == null) {
      _mostrarMensaje('Por favor selecciona un curso', Colors.redAccent);
      return;
    }
    FocusScope.of(context).unfocus();

    setState(() {
      _isRegistering = true;
    });

    try {
      final authProvider = context.read<AuthProvider>();
      final bool success = await authProvider
          .registrarUsuario(
            documento: _documentoController.text.trim(),
            nombre: _nombreController.text.trim(),
            cursoId: _cursoSeleccionadoId!,
            contrasenna: _contrasennaController.text.trim(),
          )
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw Exception('Tiempo de espera agotado');
            },
          );
      if (!mounted) return;
      if (success) {
        _limpiarFormulario();
        _mostrarMensaje('Cuenta creada exitosamente', Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
        );
      } else {
        _mostrarMensaje(
          'Error al crear cuenta. Verifica los datos.',
          Colors.redAccent,
        );
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarMensaje('Error de conexión con el servidor', Colors.redAccent);
    } finally {
      if (mounted) {
        setState(() {
          _isRegistering = false;
        });
      }
    }
  }

  void _mostrarMensaje(String mensaje, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          mensaje,
          style: AppTheme.pixelBody(size: 8, color: Colors.white),
        ),
        backgroundColor: color,
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
                  child: Column(
                    children: [
                      FormContainer(
                        title: 'Crear Cuenta',
                        subtitle: 'ÚNETE A LA AVENTURA NATURAL',
                        children: [
                          PixelTextField(
                            label: 'Nombre completo',
                            controller: _nombreController,
                            hint: 'Tu nombre',
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Requerido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          PixelTextField(
                            label: 'Documento',
                            controller: _documentoController,
                            hint: '1234567890',
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty)
                                return 'Requerido';
                              if (value.trim().length < 4)
                                return 'Mínimo 4 dígitos';
                              if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
                                return 'Solo números sin espacios';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            width: 350,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'curso',
                                  style: AppTheme.pixelBody(
                                    size: 8,
                                    color: AppColors.oliveGreen,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                _isLoadingCursos
                                    ? const Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.green,
                                        ),
                                      )
                                    : Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black,
                                            width: 3,
                                          ),
                                          borderRadius: BorderRadius.zero,
                                          color: Colors.white,
                                        ),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton<int>(
                                            value: _cursoSeleccionadoId,
                                            isExpanded: true,
                                            dropdownColor: Colors.white,
                                            hint: Text(
                                              'Selecciona tu curso',
                                              style: AppTheme.pixelBody(
                                                size: 8,
                                                color: Colors
                                                    .grey, // O AppColors.scoreGrey
                                              ),
                                            ),
                                            items: _cursos.map((curso) {
                                              return DropdownMenuItem<int>(
                                                value: (curso.idCurso),
                                                child: Text(
                                                  curso.nombre,
                                                  style: AppTheme.pixelBody(
                                                    size: 8,
                                                    color: Colors.black87,
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
                          ),
                          const SizedBox(height: 14),
                          PixelTextField(
                            label: 'Contrasena',
                            controller: _contrasennaController,
                            hint: '********',
                            obscureText: true,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty)
                                return 'Requerido';
                              if (value.length < 6)
                                return 'Mínimo 6 caracteres';
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          PixelTextField(
                            label: 'Confirmar Contrasena',
                            controller: _confirmarContrasennaController,
                            hint: '********',
                            obscureText: true,
                            textInputAction: TextInputAction.done,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty)
                                return 'Requerido';
                              if (value != _contrasennaController.text) {
                                return 'Las contraseñas no coinciden';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height: 50,
                            child: _isRegistering
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.green,
                                    ),
                                  )
                                : PixelButton(
                                    label: 'REGISTRARSE',
                                    width: 200,
                                    onPressed: _onRegister,
                                  ),
                          ),
                          const SizedBox(height: 16),
                          GestureDetector(
                            onTap: _isRegistering 
                            ? null 
                            : () {
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
