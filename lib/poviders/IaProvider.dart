import 'package:flutter/material.dart';
import 'package:front_winbin/services/IaService.dart';
import 'dart:io';

class IaProvider extends ChangeNotifier {
  bool _cargandoIA = false;
  bool get cargandoIA => _cargandoIA;
 


  Future<void> procesarReciclajeDeCamara(File fotoCapturada) async {
    _cargandoIA = true;
    notifyListeners();

    String token = '';
    int idSesion = 0;

    String? jsonRespuesta = await IAservice.analizarImagen(
      image: fotoCapturada,
      idSesion: idSesion,
      token: token
    );

    if(jsonRespuesta != null){
      print("La IA procesó todo de manera unificada y Spring Boot registró el puntaje");
      _cargandoIA = false;
      notifyListeners();
    }else {
      print("Error: La IA no pudo procesar todo");
      _cargandoIA = false;
      notifyListeners();
    }
  }
  
}