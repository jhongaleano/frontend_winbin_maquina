import 'dart:io';
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

  void _mostrarSnackBar(String mensaje) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensaje)));
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
          _mostrarSnackBar('Error: La cámara no se pudo inicializar.');
        }
      }
    } catch (e) {
      _mostrarSnackBar("Error al abrir la cámara: $e");
    }
  }

  Future<void> _capturarYProcesar(BuildContext context) async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    if (_controller!.value.isTakingPicture) return;
    try {
      XFile fotoXFile = await _controller!.takePicture();
      File fotoFile = File(fotoXFile.path);

      if (mounted) {
        _mostrarSnackBar("Foto capturada y enviada a la IA....");

        await context.read<IaProvider>().procesarReciclajeDeCamara(fotoFile);

        _mostrarSnackBar("¡Imagen procesada con éxito!");

        setState(() {
          _fotoProcesada = true;
        });
      }
    } catch (e) {
      _mostrarSnackBar("Error al capturar la imagen: $e");
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
    final idPeriodo = authProvider.idperiodo ?? 'Sin período';


    final String nombre = usuario?['nombre'] ?? 'Usuario';
    final String avatarUrl = usuario?['avatarUrl'] ?? '';
    final int puntos = usuario?['puntos'] ?? 0;
    final String rol = usuario?['rol'] ?? 'USER';
    final String nombreCurso = usuario?['curso']?['nombreCurso'] ?? 'Sin curso';

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
                backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
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
                      style: TextStyle(color: Colors.teal.shade100, fontSize: 12),
                    ),
                    Text(
                      'Período: $idPeriodo',
                      style: TextStyle(color: Colors.teal.shade200, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Puntos
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.amber.shade700,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Puntos',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '$puntos',
                      style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
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
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber[800],
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      onPressed: () => _capturarYProcesar(context),
                      icon: const Icon(Icons.camera_alt, color: Colors.white),
                      label: const Text(
                        'Tomar Foto y Procesar',
                        style: TextStyle(color: Colors.white),
                      ),
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
