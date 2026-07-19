
class LoginResponse {
  final String token;
  final String documento;

  LoginResponse({required this.token, required this.documento});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] ?? '', 
      documento: json['documento'] ?? '',
    );
  }
}


class Curso {
  final int? idCurso;
  final String nombre;
  final int puntosTotales;

  Curso({ this.idCurso, required this.nombre, required this.puntosTotales});

  factory Curso.fromJson(Map<String, dynamic> json) {
    return Curso(
      idCurso: json['id_curso'] ?? 0,
      nombre: json['nombreCurso'] ?? " sin curso ",
      puntosTotales: json['puntosTotales'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombreCurso': nombre,
      'puntosTotales': puntosTotales,
    };
  }
}


class UsuarioPerfil {
  final bool activo;
  final String avatarUrl;
  final String contrasenna;
  final Curso? curso;
  final String documento;
  final String nombre;
  final int puntos;
  final String rol;

  UsuarioPerfil({
    required this.activo,
    required this.avatarUrl,
    required this.contrasenna,
    this.curso,
    required this.documento,
    required this.nombre,
    required this.puntos,
    required this.rol,
  });

  factory UsuarioPerfil.fromJson(Map<String, dynamic> json) {
    return UsuarioPerfil(
      activo: json['activo'] ?? false,
      avatarUrl: json['avatarUrl'] ?? '',
      contrasenna: json['contrasenna'] ?? '',
      curso: json['curso'] != null ? Curso.fromJson(json['curso']) : null,
      documento: json['documento'] ?? '',
      nombre: json['nombre'] ?? '',
      puntos: json['puntos'] ?? 0,
      rol: json['rol'] ?? 'USER',
    );
  }
}

class Periodo {
  final bool activo;
  final DateTime fechaFinal;
  final DateTime fechaInicio;
  final String idPeriodo ;
  final String nombrePeriodo;
  
  
  Periodo({ required this.idPeriodo, required this.nombrePeriodo, required this.fechaInicio, required this.fechaFinal, required this.activo});

  factory Periodo.fromJson(Map<String, dynamic> json) {
    return Periodo(
      idPeriodo: json['id_periodo'] ?? '',
      nombrePeriodo: json['nombrePeriodo'] ?? '',
      fechaInicio: json['fechaInicio'] ?? '',
      fechaFinal: json['fechaFin'] ?? '',
      activo: json['activo'],
    );
  }
}