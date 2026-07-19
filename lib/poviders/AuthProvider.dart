import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_winbin/services/AuthService.dart';
import 'package:front_winbin/models/auth_models.dart';



class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _cargando = false;
  bool get cargando => _cargando;

  String? _token;
  String? get token => _token;

  String? _nombrePeriodo;
  String? get nombrePeriodo => _nombrePeriodo;

  String? _idPeriodo;
  String? get idPeriodo => _idPeriodo;

  String? _idSesion;
  String? get idSesion => _idSesion;

  UsuarioPerfil? _usuarioActual;
  UsuarioPerfil? get usuarioActual => _usuarioActual;

  static const String _keyToken = 'jwt_token';

  Future<bool> iniciarSesion(String documento, String contrasenna) async {
    _setCargando(true);

    try {
      final LoginResponse? loginResponse = await _authService.login(documento, contrasenna);

      if (loginResponse != null && loginResponse.token.isNotEmpty) {
        _token = loginResponse.token;
        await _storage.write(key: _keyToken, value: _token);

        final periodo  = await cargarPeriodo();

        if (periodo != null) {
          _nombrePeriodo = periodo.nombrePeriodo;
          _idPeriodo = periodo.idPeriodo;
        }
        
        if (_idPeriodo != null && _token != null) {
        final  sesionData = await _authService.detalleSession(
            documento: documento,
            idPeriodo: _idPeriodo!,
            token: _token!,
          );

          if (sesionData != null && sesionData.idSesion != null) {
            _idSesion = sesionData.idSesion.toString();

            print("ID de sesión: $_idSesion");
          }
        }
        await obtenerPerfilUsuario();

        _setCargando(false);
        return true;
      }
      _setCargando(false);
      return false;
    } catch (e) {
      print("Error en el login: $e");
      _setCargando(false);
      return false;
    }
  }

  Future<void> obtenerPerfilUsuario() async {
    String? tokenActual = await obtenerToken();

    if (tokenActual == null) {
      print("No hay token disponible para recargar el perfil.");
      return;
    }

    try {
      final perfil = await _authService.obtenerPerfil(token: tokenActual);

      if (perfil != null) {
        _usuarioActual = perfil;  
        notifyListeners();       
        print("Perfil recargado exitosamente. Puntos actuales: ${_usuarioActual?.puntos}");
      } else {
        print("No se pudo obtener el perfil desde AuthService.");
      }
    } catch (e) {
      print("Error al recargar el perfil del usuario: $e");
    }
  }

  Future<bool> registrarUsuario({
    required String documento,
    required String nombre,
    required int cursoId,
    required String contrasenna,
  }) async {
    _setCargando(true);
    try {
      bool exito = await _authService.registrarUsuario(
        documento,
        nombre,
        cursoId,
        contrasenna,
      );

      _setCargando(false);
      return exito;
    } catch (e) {
      _setCargando(false);
      return false;
    }
  }

  Future<List<Curso>?> cargarCursos() async {
    return await _authService.getCursos();
  }

  Future<Periodo?> cargarPeriodo() async {
    String? tokenActual = await obtenerToken();

    if (tokenActual == null) {
      print("No hay token para consultar el período");
      return null;
    }

    final response = await _authService.getPeriodo(token: tokenActual);
    if (response != null ) {
      return response;
    }
    return null;
  }

  Future<String?> obtenerToken() async {
    if (_token != null) return _token;
    _token = await _storage.read(key: _keyToken);
    return _token;
  }

  Future<void> logout() async {
    await _storage.delete(key: _keyToken);
    _token = null;
    _nombrePeriodo = null;
    _usuarioActual = null;

    print("El usuario ha cerrado sesión");

    notifyListeners();
  }

  void _setCargando(bool valor) {
    _cargando = valor;
    notifyListeners();
  }
}
