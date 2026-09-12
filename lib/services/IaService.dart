import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart'; 
import 'package:cross_file/cross_file.dart';
import 'dart:convert';
import 'package:front_winbin/models/ia_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class IAservice {

  static final String baseUrl = dotenv.env['IA_URL']!;
  static Future<AnalisisIAResponse?> analizarImagen({
    required XFile image,
    required String idSesion,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/ia-analisis');
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
        final utf8Body = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> data = jsonDecode(utf8Body);
        print("¡Éxito! Respuesta de Python: $utf8Body");
        return AnalisisIAResponse.fromJson(data);
      } else {
        print('Error al analizar imagen: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print("ERROR CRÍTICO AL CONVERTIR EL JSON: $e");
      return null;
      
    }
    
  }
  
}
  