class CompraSuscripcion {
  int? id;
  int usuarioId;
  int suscripcionId;
  DateTime fechaCompra;
  double total;

  CompraSuscripcion({
    this.id,
    required this.usuarioId,
    required this.suscripcionId,
    required this.fechaCompra,
    required this.total,
  });

  // Para convertir un mapa a un objeto de CompraSuscripcion
  factory CompraSuscripcion.fromJson(Map<String, dynamic> json) =>
      CompraSuscripcion(
        id: json["id"],
        usuarioId: json["usuario_id"],
        suscripcionId: json["suscripcion_id"],
        fechaCompra: DateTime.parse(json["fecha_compra"]),
        total: json["total"],
      );

  // Para convertir un objeto de CompraSuscripcion a un mapa
  Map<String, dynamic> toJson() => {
        "id": id,
        "usuario_id": usuarioId,
        "suscripcion_id": suscripcionId,
        "fecha_compra": fechaCompra.toIso8601String(),
        "total": total,
      };
}
