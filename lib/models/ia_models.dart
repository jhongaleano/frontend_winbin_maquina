class AnalisisIAResponse {
  final String status;
  final String objetoDetectado;
  final double acertacionConfianza;
  final String? msg;
  final String tamanoCalculado;
  final int idCategoriaPuntaje;
  final Map<String, dynamic>? envioBackend;
  final int idMaterial;

  AnalisisIAResponse({
    required this.status,
    required this.objetoDetectado,
    required this.acertacionConfianza,
    this.msg,
    required this.tamanoCalculado,
    required this.idCategoriaPuntaje,
    this.envioBackend,
    required this.idMaterial,
  });

  factory AnalisisIAResponse.fromJson(Map<String, dynamic> json) {
    return AnalisisIAResponse(
      status: json['status'] ?? 'error',
      objetoDetectado: json['objeto_detectado'] ?? 'Desconocido',
      acertacionConfianza: (json['acertacion_confianza'] ?? 0.0).toDouble(),
      msg: json['msg'],
      tamanoCalculado: json['tamano_calculado'] ?? 'No especificado',
      idCategoriaPuntaje: (json['id_categoria_puntaje'] ?? 0).toInt(),
      envioBackend: json['envio_backend'],
      idMaterial: (json['id_material'] ?? 0).toInt(),
    );
  }
}