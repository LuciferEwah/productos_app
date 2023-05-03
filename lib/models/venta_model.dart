class DetalleVentaModel {
  int? id;
  int? ventaId;
  int? productoId;
  int? cantidad;
  double? subtotal;

  DetalleVentaModel({
    this.id,
    required this.ventaId,
    required this.productoId,
    required this.cantidad,
    required this.subtotal,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'venta_id': ventaId,
        'producto_id': productoId,
        'cantidad': cantidad,
        'subtotal': subtotal,
      };

  factory DetalleVentaModel.fromJson(Map<String, dynamic> json) =>
      DetalleVentaModel(
        id: json['id'],
        ventaId: json['venta_id'],
        productoId: json['producto_id'],
        cantidad: json['cantidad'],
        subtotal: json['subtotal'],
      );
}

class VentaModel {
  int? id;
  String? fecha;
  double? total;
  int? usuarioId;

  VentaModel({
    this.id,
    required this.fecha,
    required this.total,
    required this.usuarioId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'fecha': fecha,
        'total': total,
        'usuario_id': usuarioId,
      };

  factory VentaModel.fromJson(Map<String, dynamic> json) => VentaModel(
        id: json['id'],
        fecha: json['fecha'],
        total: json['total'],
        usuarioId: json['usuario_id'],
      );
}
