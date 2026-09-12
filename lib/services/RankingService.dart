import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_winbin/models/auth_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RankingService {
  static final String baseUrl = dotenv.env['API_URL']!;

  Future<UsuarioPerfil?> getTopUsuario() async {
    final url = Uri.parse('$baseUrl/ranking/top-usuario');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Ranking obtenido');
        return UsuarioPerfil.fromJson(data);
      } else {
        print('Error al obtener ranking: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Excepción al obtener ranking: $e');
      return null;
    }
  }


  Future<Curso?> getTopCurso() async {
    final url = Uri.parse('$baseUrl/top-curso');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Curso ranking obtenido ');
        return Curso.fromJson(data);
      } else {
        print('Error al obtener ranking: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Excepción al obtener ranking: $e');
      return null;
    }
  }
}