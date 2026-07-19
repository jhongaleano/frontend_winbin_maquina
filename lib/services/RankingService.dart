import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:front_winbin/models/auth_models.dart';

class RankingService {
  static const String baseUrl = 'http://localhost:8080/api/ranking';

  Future<UsuarioPerfil?> getTopUsuario() async {
    final url = Uri.parse('$baseUrl/top-usuario');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Ranking obtenido : $data');
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
        print('Curso ranking obtenido : $data');
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