import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<bool> login(String documento, String contrasenna) async {
    final url = Uri.parse('$baseUrl/auth/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'documento': documento, 'contrasenna': contrasenna}),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print('Login exitoso: ${data}');
        return true;
      } else {
        print('Error al iniciar sesión: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getCursos() async {
    final url = Uri.parse('$baseUrl/cursos');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        print('cursos obtenidos : ${jsonDecode(response.body)}');
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print('Error al obtener cursos: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Excepción al obtener cursos: $e');
      return [];
    }
  }

  Future<bool> registrarUsuario(
    String documento,
    String nombre,
    int cursoId,
    String contrasenna,
  ) async {
    final url = Uri.parse('$baseUrl/usuarios/registro');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({
          'documento': documento,
          'nombre': nombre,
          'curso': {'id_curso': cursoId},
          'contrasenna': contrasenna,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('Usuario registrado con éxito');
        return true;
      } else {
        print('Error en registro: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Excepción al conectar con el servidor: $e');
      return false;
    }
  }

  Future<bool> detallesSession(Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/DetalleSession/crear');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Detalle de sesión creado con éxito');
        return true;
      } else {
        print('Error en creación de detalle de sesión: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error en creación de detalle de sesión: $e');
      return false;
    }
  }
}
