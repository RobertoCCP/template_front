class Producto {
  final String codproducto;
  final String nombre;
  final int umv;
  final String estado;
  final String codtipoproducto;
  final double costo;
  final String unidadmedida;
  final String codmarca;
  final String porcimpuesto;
  final String porcdescuento;
  final String? descuento;

  Producto({
    required this.codproducto,
    required this.nombre,
    required this.umv,
    required this.estado,
    required this.codtipoproducto,
    required this.costo,
    required this.unidadmedida,
    required this.codmarca,
    required this.porcimpuesto,
    required this.porcdescuento,
    this.descuento,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      codproducto: json['codproducto'] ?? '',
      nombre: json['nombre'] ?? '',
      umv: json['umv'] ?? 0,
      estado: json['estado'] ?? '',
      codtipoproducto: json['codtipoproducto'] ?? '',
      costo: double.parse(json['costo'].toString()),
      unidadmedida: json['unidadmedida'] ?? '',
      codmarca: json['codmarca'] ?? '',
      porcimpuesto: json['porcimpuesto'] ?? '0.00',
      porcdescuento: json['porcdescuento'] ?? '0.00',
      descuento: json['descuento'],
    );
  }

  Map<String, dynamic> toJson() => {
    'codproducto': codproducto,
    'nombre': nombre,
    'umv': umv,
    'estado': estado,
    'codtipoproducto': codtipoproducto,
    'costo': costo,
    'unidadmedida': unidadmedida,
    'codmarca': codmarca,
    'porcimpuesto': porcimpuesto,
    'porcdescuento': porcdescuento,
    'descuento': descuento,
  };
}