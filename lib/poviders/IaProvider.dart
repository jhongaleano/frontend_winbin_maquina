import 'package:flutter/material.dart';
import 'package:cross_file/cross_file.dart';
import '../services/IaService.dart';
import '../models/ia_models.dart';

class IaProvider extends ChangeNotifier {
  bool _cargandoIA = false;
  bool get cargandoIA => _cargandoIA;

 
  AnalisisIAResponse? _resultadoIA;
  AnalisisIAResponse? get resultadoIA => _resultadoIA;

  Future<bool> procesarReciclajeDeCamara({
    required XFile fotoCapturada,
    required String idSesion,
    required String token,
  }) async {
    _cargandoIA = true;
    _resultadoIA = null;
    notifyListeners();
    try {
      final respuesta = await IAservice.analizarImagen(
        image: fotoCapturada,
        idSesion: idSesion,
        token: token,
      );

      _cargandoIA = false;

      if (respuesta != null) {
        _resultadoIA = respuesta;

        if (respuesta.status == 'éxito') {
          print("¡Éxito! Objeto válido detectado y puntaje registrado en Spring Boot.");
          notifyListeners();
          return true; 
        } else if (respuesta.status == 'no_reciclable') {
          print("Atención: El objeto no es reciclable -> ${respuesta.status}");
          notifyListeners();
          return false; 
        }
      }
      print("Error: La respuesta de la IA vino nula o con formato no reconocido.");
      notifyListeners();
      return false;

    } catch (e) {
      print("Excepción en IaProvider: $e");
      _cargandoIA = false;
      notifyListeners();
      return false;
    }
  }
  
}