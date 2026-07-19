import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:front_winbin/poviders/IaProvider.dart';
import 'package:front_winbin/poviders/AuthProvider.dart';
import 'package:front_winbin/screens/home_screen.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isCameraInitialized = false;
  bool _fotoProcesada = false;

  void _mostrarSnackBar(String mensaje, {Color backgroundColor = Colors.black87}) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar(); // Limpia la anterior para no solaparlas
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  Future<void> _encenderCamara() async {
    try {
      _cameras = await availableCameras();

      if (_cameras != null && _cameras!.isNotEmpty) {
        _controller = CameraController(
          _cameras!.first,
          ResolutionPreset.medium,
          enableAudio: false,
        );
        await _controller!.initialize();

        if (mounted) {
          setState(() {
            _isCameraInitialized = true;
          });
        } else {
          _mostrarSnackBar('Error: La cámara no se pudo inicializar.', backgroundColor: Colors.red);
        }
      }
    } catch (e) {
      _mostrarSnackBar("Error al abrir la cámara: $e", backgroundColor: Colors.red);
    }
  }

  Future<void> _capturarYProcesar(BuildContext context) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (_controller!.value.isTakingPicture) return;

    try {
      final authProvider = context.read<AuthProvider>();
      final iaProvider = context.read<IaProvider>();
      final token = authProvider.token;
      final idSesion = authProvider.idSesion;

      if (token == null || token.isEmpty || idSesion == null) {
        _mostrarSnackBar("Error: Sesión no válida o sin período activo.", backgroundColor: Colors.red);
        return;
      }

      XFile fotoXFile = await _controller!.takePicture();

      if (mounted) {
        _mostrarSnackBar("Foto capturada y enviada a la IA....", backgroundColor: Colors.blueGrey);

        bool exito = await iaProvider.procesarReciclajeDeCamara(
          fotoCapturada: fotoXFile,
          idSesion: idSesion,
          token: token,
        );
        final resultado = iaProvider.resultadoIA;

        if (exito && resultado != null) {
          String objeto = resultado['objeto_detectado'];
          num confianza = resultado['acertacion_confianza'];
          _mostrarSnackBar(
            '¡Éxito! Detectado: $objeto ($confianza%)',
            backgroundColor: Colors.green.shade700,
          );
          setState(() {
            _fotoProcesada = true;
          });
          await authProvider.obtenerPerfilUsuario();

        } else if (resultado != null &&
            resultado['status'] == 'no_reciclable') {
          String mensaje = resultado['msg'];

          _mostrarSnackBar(
            mensaje,
            backgroundColor: Colors.amber.shade900,
          );
        } else {
          _mostrarSnackBar(
            'Error al procesar la imagen',
            backgroundColor: Colors.red.shade700,
          );
        }

        
      }
    } catch (e) {
      _mostrarSnackBar("Error al capturar la imagen: $e", backgroundColor: Colors.red);
    }
  }

  void _reiniciarCamara() {
    setState(() {
      _fotoProcesada = false;
    });
  }

  Future<void> _cerrarSesion() async {
    await context.read<AuthProvider>().logout();

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute<void>(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final usuario = authProvider.usuarioActual;
    final periodo = authProvider.nombrePeriodo;

    final String nombre = usuario?.nombre ?? 'Usuario';
    final String avatarUrl = usuario?.avatarUrl ?? '';
    final int puntos = usuario?.puntos ?? 0;
    final String rol = usuario?.rol ?? 'USER';
    final String nombreCurso = usuario?.curso?.nombre ?? 'Sin curso' ;

    return Scaffold(
      appBar: AppBar(
        title: const Text('WinBin - Escáner de Reciclaje'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _cerrarSesion,
            tooltip: 'Cerrar Sesión',
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12.0),
            color: Colors.teal.shade900,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.teal.shade200,
                  backgroundImage: avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl.isEmpty
                      ? const Icon(Icons.person, size: 28, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola, $nombre!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Curso: $nombreCurso | Rol: $rol',
                        style: TextStyle(
                          color: Colors.teal.shade100,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Periodo: $periodo',
                        style: TextStyle(
                          color: Colors.teal.shade200,
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                // Puntos
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade700,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Puntos',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$puntos',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.black,
              child: Center(
                child: _isCameraInitialized
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: CameraPreview(_controller!),
                      )
                    : const Text(
                        'Cámara apagada. Presione iniciar.',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
              ),
            ),
          ),

          Container(
            padding: const EdgeInsets.all(24.0),
            color: Colors.grey[900],
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!_isCameraInitialized)
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: _encenderCamara,
                      icon: const Icon(Icons.videocam, color: Colors.white),
                      label: const Text(
                        'Iniciar Cámara',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  else if (!_fotoProcesada)
                    Consumer<IaProvider>(
                      builder: (context, iaProv, child) {
                        return ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[800],
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          onPressed: iaProv.cargandoIA ? null : () => _capturarYProcesar(context),
                          icon: iaProv.cargandoIA
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Icon(Icons.camera_alt, color: Colors.white),
                          label: Text(
                            iaProv.cargandoIA ? 'Procesando...' : 'Tomar Foto y Procesar',
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      },
                    )     
                  else
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => _reiniciarCamara(),
                      icon: const Icon(Icons.refresh, color: Colors.white),
                      label: const Text(
                        '¿Quieres reciclar de nuevo?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onPressed: _cerrarSesion,
                    icon: const Icon(Icons.exit_to_app, color: Colors.white),
                    label: const Text(
                      'Terminar proceso',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
