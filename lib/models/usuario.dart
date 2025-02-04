class Usuario {
  final String codcliente;
  final String codtipocliente;
  final String nombre;
  final String email;
  final String pais;
  final String provincia;
  final String? ciudad;
  final String codvendedor;
  final String codformapago;
  final String estado;
  final double limitecredito;
  final double saldopendiente;
  final String cedularuc;
  final String codlistaprecio;
  final String calificacion;
  final String nombrecomercial;
  final String login;
  final String token;

  Usuario({
    required this.codcliente,
    required this.codtipocliente,
    required this.nombre,
    required this.email,
    required this.pais,
    required this.provincia,
    this.ciudad,
    required this.codvendedor,
    required this.codformapago,
    required this.estado,
    required this.limitecredito,
    required this.saldopendiente,
    required this.cedularuc,
    required this.codlistaprecio,
    required this.calificacion,
    required this.nombrecomercial,
    required this.login,
    required this.token,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    var datosUsuario = json['data_usuario'];
    return Usuario(
      codcliente: datosUsuario['codcliente'] ?? '',
      codtipocliente: datosUsuario['codtipocliente'] ?? '',
      nombre: datosUsuario['nombre'] ?? '',
      email: datosUsuario['email'] ?? '',
      pais: datosUsuario['pais'] ?? '',
      provincia: datosUsuario['provincia'] ?? '',
      ciudad: datosUsuario['ciudad'],
      codvendedor: datosUsuario['codvendedor'] ?? '',
      codformapago: datosUsuario['codformapago'] ?? '',
      estado: datosUsuario['estado'] ?? '',
      limitecredito: datosUsuario['limitecredito']?.toDouble() ?? 0.0,
      saldopendiente: datosUsuario['saldopendiente']?.toDouble() ?? 0.0,
      cedularuc: datosUsuario['cedularuc'] ?? '',
      codlistaprecio: datosUsuario['codlistaprecio'] ?? '',
      calificacion: datosUsuario['calificacion'] ?? '',
      nombrecomercial: datosUsuario['nombrecomercial'] ?? '',
      login: datosUsuario['login'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'data_usuario': {
      'codcliente': codcliente,
      'codtipocliente': codtipocliente,
      'nombre': nombre,
      'email': email,
      'pais': pais,
      'provincia': provincia,
      'ciudad': ciudad,
      'codvendedor': codvendedor,
      'codformapago': codformapago,
      'estado': estado,
      'limitecredito': limitecredito,
      'saldopendiente': saldopendiente,
      'cedularuc': cedularuc,
      'codlistaprecio': codlistaprecio,
      'calificacion': calificacion,
      'nombrecomercial': nombrecomercial,
      'login': login,
    },
    'token': token,
  };
}