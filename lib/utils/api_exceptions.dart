class UnauthorizedException implements Exception {
  final String mensaje = 'El token expiró o es inválido';
  
  @override
  String toString() => mensaje;
}
