import 'dart:io';
import 'package:http/http.dart' as http;

class IAservice {

  static const String baseUrl = 'http://localhost:8080/api';
  static Future<String?> analizarImagen({
    required File image,
    required int idSesion,
    required String token
    
  }) async {
    final url = Uri.parse('$baseUrl/ia/analizar');
    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['id_sesion'] = idSesion.toString();

    var multipartFile = await http.MultipartFile.fromPath(
      'imagen',
      image.path,
    );
    request.files.add(multipartFile);

    try {
      print("Enviando datos a Python...");
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      if (response.statusCode == 200) {
        print("¡Éxito! Respuesta de Python: ${response.body}");
        return response.body;
      } else {
        print('Error al analizar imagen: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error de conexión: $e');
      return null;
    }
    
  }
  
}
  