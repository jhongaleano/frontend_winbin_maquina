import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; 
import 'package:cross_file/cross_file.dart';
import 'dart:convert';

class IAservice {

  static const String baseUrl = 'http://127.0.0.1:8000/api';
  static Future<Map<String, dynamic>?> analizarImagen({
    required XFile image,
    required String idSesion,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/ia/analizar');
    var request = http.MultipartRequest('POST', url);

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['id_session'] = idSesion.toString();

    try {
      final bytes = await image.readAsBytes();

      var multipartFile = http.MultipartFile.fromBytes(
        'file', 
        bytes,
        filename: image.name.isNotEmpty ? image.name : 'captura.jpg',
        contentType: MediaType('image', 'jpeg'),
      );

      request.files.add(multipartFile);

      print("Enviando datos a Python...");
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print("¡Éxito! Respuesta de Python: ${response.body}");
        return data;
      } else {
        print('Error al analizar imagen: ${response.statusCode} - ${response.body}');
        return null;
      }
      
    } catch (e) {
      print('Error al leer la imagen: $e');
      return null;
    }
    
  }
  
}
  