import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:front_winbin/models/auth_models.dart';
import '../services/RankingService.dart'; 
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RankingProvider with ChangeNotifier {
  StompClient? _stompClient;
  bool _isConnected = false;
  final RankingService _rankingService = RankingService();

  UsuarioPerfil? _topUsuario;
  UsuarioPerfil? get topUsuario => _topUsuario;
  
  Curso? _topCurso;
  Curso? get topCurso => _topCurso;

  bool _cargandoRanking = false;
  bool get cargandoRanking => _cargandoRanking;
  bool get isConnected => _isConnected;

  Future<void> cargarLeaderboard() async {
    _cargandoRanking = true;
    notifyListeners();

    try {
      
      _topUsuario = await _rankingService.getTopUsuario();
      _topCurso = await _rankingService.getTopCurso();

      
    } catch (e) {
      print("Error detallado en RankingProvider: $e");
    } finally {
      _cargandoRanking = false;
      notifyListeners();
    }
  }

  void conectarWebsocket() {
    if (_isConnected) return;

    cargarLeaderboard();

    final String socketUrl = dotenv.env['WS_URL'] ?? '';
    print("URL DEL WEBSOCKET CARGADA: $socketUrl");

    _stompClient = StompClient(
      config: StompConfig(
        url: socketUrl,
        onConnect: (StompFrame frame) {
          _isConnected = true;
          print("¡CONEXIÓN WEBSOCKET EXITOSA!");
          notifyListeners();

          _stompClient?.subscribe(
            destination: '/topic/ranking/estudiante-top',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                final Map<String, dynamic> data = json.decode(frame.body!);
                _topUsuario = UsuarioPerfil.fromJson(data);
                notifyListeners();
              }
            },
          );

          _stompClient?.subscribe(
            destination: '/topic/ranking/curso-top',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                final Map<String, dynamic> data = json.decode(frame.body!);
                _topCurso = Curso.fromJson(data);
                notifyListeners(); 
              }
            },
          );
        },
        onWebSocketError: (dynamic error) => print('Error en el WebSocket: $error'),
        onStompError: (StompFrame frame) => print('Error del Protocolo STOMP: ${frame.body}'), 
        onDisconnect: (StompFrame frame) => print('Desconectado del WebSocket'), 
      ),
    );

    _stompClient?.activate();
  }

  void desconectar() {
    _stompClient?.deactivate();
    _isConnected = false;
    notifyListeners();
  }

  
}