import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_winbin/services/AuthService.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _cargando = false;
  bool get cargando => _cargando;

  String? _token;
  String? get token => _token;

  String? _idperiodo;
  String? get idperiodo => _idperiodo;

  Map<String, dynamic>? _usuarioActual;
  Map<String, dynamic>? get usuarioActual => _usuarioActual;

  static const String _keyToken = 'jwt_token';

  Future<bool> iniciarSesion(String documento, String contrasenna) async {
    _setCargando(true);

    try {
      final response = await _authService.login(documento, contrasenna);

      if (response != null && response.containsKey('token')) {
        _token = response['token'];
        await _storage.write(key: _keyToken, value: _token);

        final periodoData = await cargarPeriodo();

        if (periodoData != null && periodoData.containsKey('id_periodo')) {
          _idperiodo = periodoData['id_periodo'].toString();

          await _authService.detallesSession(
            documento: documento,
            idPeriodo: _idperiodo!,
            token: _token!,
          );
        }

        final perfil = await _authService.obtenerPerfil(token: _token!);
        if (perfil != null) {
          _usuarioActual = perfil;
        }

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

  Future<List<Map<String, dynamic>>> cargarCursos() async {
    return await _authService.getCursos();
  }

  Future<Map<String, dynamic>?> cargarPeriodo() async {
    String? tokenActual = await obtenerToken();

    if (tokenActual == null) {
      print("No hay token para consultar el período");
      return null;
    }

    final response = await _authService.getPeriodo(token: tokenActual);
    if (response != null && response.containsKey('id_periodo')) {
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
    _idperiodo = null;
    _usuarioActual = null;

    print("El usuario ha cerrado sesión");

    notifyListeners();
  }

  void _setCargando(bool valor) {
    _cargando = valor;
    notifyListeners();
  }
}
