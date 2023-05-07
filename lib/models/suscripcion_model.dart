import 'dart:convert';

class Suscripciones {
  int id;
  DateTime fechaInicio;
  DateTime fechaFin;
  String estado;
  int idUsuario;
  int idPlan;

  Suscripciones({
    required this.id,
    required this.fechaInicio,
    required this.fechaFin,
    required this.estado,
    required this.idUsuario,
    required this.idPlan,
  });

  factory Suscripciones.fromRawJson(String str) =>
      Suscripciones.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Suscripciones.fromJson(Map<String, dynamic> json) => Suscripciones(
        id: json["id"],
        fechaInicio: DateTime.parse(json["fecha_inicio"]),
        fechaFin: DateTime.parse(json["fecha_fin"]),
        estado: json["estado"],
        idUsuario: json["id_usuario"],
        idPlan: json["id_plan"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fecha_inicio":
            "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
        "fecha_fin":
            "${fechaFin.year.toString().padLeft(4, '0')}-${fechaFin.month.toString().padLeft(2, '0')}-${fechaFin.day.toString().padLeft(2, '0')}",
        "estado": estado,
        "id_usuario": idUsuario,
        "id_plan": idPlan,
      };
}
