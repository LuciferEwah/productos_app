import 'dart:convert';

class PlanModel {
  int? id;
  String nombre;
  double precioMensual;
  int duracionMeses;
  int renovacionAutomatica;

  PlanModel({
    this.id,
    required this.nombre,
    required this.precioMensual,
    required this.duracionMeses,
    required this.renovacionAutomatica,
  });

  factory PlanModel.fromRawJson(String str) =>
      PlanModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PlanModel.fromJson(Map<String, dynamic> json) => PlanModel(
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
  PlanModel copy() => PlanModel(  //COPIA PRODUCTO
      nombre: nombre,
      precioMensual: precioMensual,
      duracionMeses: duracionMeses,
      id: id,
      renovacionAutomatica: renovacionAutomatica);
}



