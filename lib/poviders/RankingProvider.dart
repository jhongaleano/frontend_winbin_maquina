import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front_winbin/models/auth_models.dart';
import '../services/RankingService.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RankingProvider with ChangeNotifier {
  StompClient? _stompClient;
  bool _isConnected = false;
  bool _disposed = false;
  final RankingService _rankingService = RankingService();

  UsuarioPerfil? _topUsuario;
  UsuarioPerfil? get topUsuario => _topUsuario;

  Curso? _topCurso;
  Curso? get topCurso => _topCurso;

  bool _cargandoRanking = false;
  bool get cargandoRanking => _cargandoRanking;
  bool get isConnected => _isConnected;

  void _notificar() {
    if (!_disposed) notifyListeners();
  }

  Future<void> cargarLeaderboard() async {
    _cargandoRanking = true;
    _notificar();
    try {
      _topUsuario = await _rankingService.getTopUsuario();
      _topCurso = await _rankingService.getTopCurso();
    } catch (e) {
      print("Error detallado en RankingProvider: $e");
    } finally {
      _cargandoRanking = false;
      _notificar();
    }
  }

  void conectarWebsocket() {
    if (_stompClient != null) return;

    cargarLeaderboard();


    final String socketUrl = dotenv.env['WS_URL'] ?? '';

    _stompClient = StompClient(
      config: StompConfig(
        url: socketUrl,
        onConnect: (StompFrame frame) {
          _isConnected = true;
          _notificar();

          _stompClient?.subscribe(
            destination: '/topic/ranking/estudiante-top',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                final Map<String, dynamic> data = json.decode(frame.body!);
                _topUsuario = UsuarioPerfil.fromJson(data);
                _notificar();
              }
            },
          );

          _stompClient?.subscribe(
            destination: '/topic/ranking/curso-top',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                final Map<String, dynamic> data = json.decode(frame.body!);
                _topCurso = Curso.fromJson(data);
                _notificar();
              }
            },
          );
        },
        onWebSocketError: (dynamic error) =>
            debugPrint('Error en el WebSocket: $error'),
        onStompError: (StompFrame frame) =>
            debugPrint('Error del Protocolo STOMP: ${frame.body}'),
        onDisconnect: (StompFrame frame) =>
            debugPrint('Desconectado del WebSocket'),
      ),
    );

    _stompClient?.activate();
  }

  void desconectar({bool notificar = true}) {
    _stompClient?.deactivate();
    _stompClient = null;
    _isConnected = false;
    if (notificar) _notificar();
  }

  @override
  void dispose() {
    _disposed = true;
    desconectar(notificar: false);
    super.dispose();
  }
}
