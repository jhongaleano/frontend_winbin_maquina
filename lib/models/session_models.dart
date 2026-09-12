import 'auth_models.dart';

class DetalleSessionResponse {
  final String? idSesion;
  final UsuarioPerfil documento;
  final DateTime?fechaHora;
  final int? idCategoria;
  final Periodo idPeriodo;

  DetalleSessionResponse({
    required this.documento,
    required this.idPeriodo,
    this.idSesion,
    this.fechaHora,
    this.idCategoria,

  });

  factory DetalleSessionResponse.fromJson(Map<String, dynamic> json) {
    return DetalleSessionResponse(
      idSesion: json['id_session'],
      documento: UsuarioPerfil.fromJson(json['documento'] ?? {}),
      idPeriodo: Periodo.fromJson(json['id_periodo'] ?? {}),
      fechaHora: json['fechaHora'] != null ? DateTime.parse(json['fechaHora']) : null,
      idCategoria: json['idCategoria'],
    );
  }

}