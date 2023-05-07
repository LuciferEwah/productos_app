import 'dart:convert';

class PlanesDeSuscripcion {
  int id;
  String nombre;
  double precioMensual;
  int duracionMeses;
  bool renovacionAutomatica;

  PlanesDeSuscripcion({
    required this.id,
    required this.nombre,
    required this.precioMensual,
    required this.duracionMeses,
    required this.renovacionAutomatica,
  });

  factory PlanesDeSuscripcion.fromRawJson(String str) =>
      PlanesDeSuscripcion.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlanesDeSuscripcion.fromJson(Map<String, dynamic> json) =>
      PlanesDeSuscripcion(
        id: json["id"],
        nombre: json["nombre"],
        precioMensual: json["precio_mensual"]?.toDouble(),
        duracionMeses: json["duracion_meses"],
        renovacionAutomatica: json["renovacion_automatica"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "precio_mensual": precioMensual,
        "duracion_meses": duracionMeses,
        "renovacion_automatica": renovacionAutomatica,
      };
}
