import 'package:flutter/material.dart';
import 'package:front_winbin/models/auth_models.dart';
import '../services/RankingService.dart'; 

class RankingProvider extends ChangeNotifier {
  final RankingService _rankingService = RankingService();

  UsuarioPerfil? _topUsuario;
  UsuarioPerfil? get topUsuario => _topUsuario;
  
  Curso? _topCurso;
  Curso? get topCurso => _topCurso;

  bool _cargandoRanking = false;
  bool get cargandoRanking => _cargandoRanking;

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
}