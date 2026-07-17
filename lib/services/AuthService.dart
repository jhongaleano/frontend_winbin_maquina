import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080/api';

  Future<Map<String, dynamic>?> login(String documento, String contrasenna) async {
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
        return data;
      } else {
        print('Error al iniciar sesión: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error al iniciar sesión: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> detalleSession({
  required String documento,
  required String idPeriodo,
  required String token,
 } ) async {
    final url = Uri.parse('$baseUrl/DetalleSession');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'documento': {
            'documento': documento,
          },
          'id_periodo': {
            'id_periodo': idPeriodo,
          },
        }),
      );

      if (response.statusCode == 200) {
        print('Detalles del usuario obtenidos: ${jsonDecode(response.body)}');
        return Map<String, dynamic>.from(jsonDecode(response.body));
      } else {
        print('Error al obtener detalles del usuario: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error al obtener detalles del usuario: $e');
      return null;
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

  Future<Map<String, dynamic>?> obtenerPerfil({required String token}) async {
    final url = Uri.parse('$baseUrl/usuarios/perfil');

    try {
      final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      }
      );

      if (response.statusCode == 200) {
        print('perfiles obtenidos :${response.body}');
        return Map<String, dynamic>.from(jsonDecode(response.body));
      } else {
        print('Error al obtener perfil: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Excepción al obtener perfil: $e');
      return null;
    }
  }


  Future<Map<String, dynamic>> getPeriodo({required String token}) async {
    final url = Uri.parse('$baseUrl/PeriodoRanking/activo');

    try {
      final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      );

      if (response.statusCode == 200) {
        print('Periodo obtenido : ${jsonDecode(response.body)}');
        return Map<String, dynamic>.from(jsonDecode(response.body));
      } else {
        print('Error al obtener periodo: ${response.statusCode}');
        return {};
      }
    } catch (e) {
      print('Excepción al obtener cursos: $e');
      return {};
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

  Future<Map<String, dynamic>?> detallesSession({
    required String documento,
    required String idPeriodo,
    required String token,
    }) async {
    final url = Uri.parse('$baseUrl/DetalleSession');

    try {
      final response = await http.post(
        url,
        headers: 
        {
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token',
        },

        body: jsonEncode({
          'documento': {
            'documento': documento,
          },
          'id_periodo': {
            'id_periodo': idPeriodo,
          },
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Detalle de sesión creado con éxito');
        return Map<String, dynamic>.from(jsonDecode(response.body));
      } else {
        print('Error en creación de detalle de sesión: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error en creación de detalle de sesión: $e');
      return null;
    }
  }
}
