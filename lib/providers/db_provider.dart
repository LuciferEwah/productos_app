import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:productos_app/models/models.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await initDB();
      return _database;
    }
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ProductosDB2.db');

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      // Crea la tabla 'usuario'
      await db.execute(
          'CREATE TABLE USUARIO (id INTEGER PRIMARY KEY, email TEXT, contrasena TEXT, rol TEXT)');
      // Crea la tabla 'planes_de_suscripcion'
      await db.execute(
          'CREATE TABLE PLANES_DE_SUSCRIPCION (id INTEGER PRIMARY KEY, nombre TEXT, precio_mensual REAL, duracion_meses INT, renovacion_automatica INTEGER)');
      // Crea la tabla 'suscripciones'
      await db.execute(
          'CREATE TABLE SUSCRIPCIONES (id INTEGER PRIMARY KEY, fecha_inicio DATE, fecha_fin DATE, estado TEXT, id_usuario INTEGER, id_plan INTEGER, FOREIGN KEY (id_usuario) REFERENCES USUARIO (id), FOREIGN KEY (id_plan) REFERENCES PLANES_DE_SUSCRIPCION (id))');
      // Crea la tabla 'producto'
      await db.execute(
          'CREATE TABLE PRODUCTO (id INTEGER PRIMARY KEY, nombre TEXT, categoria TEXT, precio REAL, stock INTEGER, imagen TEXT)');
      // Crea la tabla 'venta'
      await db.execute(
          'CREATE TABLE VENTA (id INTEGER PRIMARY KEY, fecha TEXT, total REAL, usuario_id INTEGER, FOREIGN KEY(usuario_id) REFERENCES USUARIO(id))');
      // Crea la tabla 'detalle_venta'
      await db.execute(
          'CREATE TABLE DETALLE_VENTA (id INTEGER PRIMARY KEY, venta_id INTEGER, producto_id INTEGER, cantidad INTEGER, subtotal REAL, FOREIGN KEY(venta_id) REFERENCES VENTA(id), FOREIGN KEY(producto_id) REFERENCES PRODUCTO(id))');
// Crea la tabla 'compra_suscripcion'
      await db.execute(
          'CREATE TABLE COMPRA_SUSCRIPCION (id INTEGER PRIMARY KEY, usuario_id INTEGER, suscripcion_id INTEGER, fecha_compra DATE, total REAL, FOREIGN KEY(usuario_id) REFERENCES USUARIO(id), FOREIGN KEY(suscripcion_id) REFERENCES SUSCRIPCIONES(id))');
    });
  }

//////////////////////////////////////////////// producto ////////////////////////////////////////////////
  Future<ProductModel> newProduct(ProductModel newProduct) async {
    final db = await database;
    final res = await db?.insert('PRODUCTO', newProduct.toJson());

    // Asigna el id generado automáticamente al producto y lo devuelve.
    newProduct.id = res;
    return newProduct;
  }

  Future<ProductModel> getProductById(int id) async {
    final db = await database;
    final result = await db!.query(
      'PRODUCTO',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return ProductModel.fromJson(result.first);
    } else {
      throw Exception('Product not found');
    }
  }

  Future<List<ProductModel>> getProductAll() async {
    final db = await database;
    final res = await db!.query('PRODUCTO');
    return res.isNotEmpty
        ? res.map((e) => ProductModel.fromJson(e)).toList()
        : [];
  }

  Future<List<ProductModel>> getProductByType(String categoria) async {
    final db = await database;
    final res = await db!
        .query('PRODUCTO', where: 'categoria = ?', whereArgs: [categoria]);
    return res.isNotEmpty
        ? res.map((e) => ProductModel.fromJson(e)).toList()
        : [];
  }

  Future<int?> updateProduct(ProductModel updateProduct) async {
    final db = await database;
    final res = await db!.update('PRODUCTO', updateProduct.toJson(),
        where: 'id = ?', whereArgs: [updateProduct.id]);
    return res;
  }

  Future<int?> deleteProductById(int id) async {
    final db = await database;
    final res = await db!.delete('PRODUCTO', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int?> deleteProductAll() async {
    final db = await database;
    final res = await db!.delete('PRODUCTO');
    return res;
  }

  Future<int?> discountItemQuantity(int id, int quantity) async {
    final db = DBProvider.db;
    final product = await db.getProductById(id);
    final newQuantity = product.stock - quantity;
    if (newQuantity < 0) {
      throw Exception('no hay stock');
    }
    final updatedProduct = ProductModel(
        id: product.id,
        nombre: product.nombre,
        precio: product.precio,
        stock: newQuantity,
        imagen: product.imagen);
    return await db.updateProduct(updatedProduct);
  }

//////////////////////////////////////////////// usuario ////////////////////////////////////////////////
  Future<UserModel> newUser(UserModel newUser) async {
    final db = await database;
    final res = await db?.insert('USUARIO', newUser.toJson());
    // Asigna el ID generado automáticamente al usuario y lo devuelve.
    newUser.id = res;
    return newUser;
  }

  getUserEmail(String email) async {
    final db = await database;
    final res =
        await db!.query('USUARIO', where: 'email = ?', whereArgs: [email]);
    return res.isNotEmpty ? res.map((e) => UserModel.fromJson(e)).toList() : [];
  }

  Future<List<UserModel>> getUserAll() async {
    final db = await database;
    final res = await db!.query('USUARIO');
    return res.isNotEmpty ? res.map((e) => UserModel.fromJson(e)).toList() : [];
  }

  Future<int?> deleteUserById(int id) async {
    final db = await database;
    final res = await db!.delete('USUARIO', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  //////////////////////////////////////////////// venta ////////////////////////////////////////////////
  Future<List<VentaModel>> getVentasAll() async {
    final db = await database;
    final res = await db!.query('VENTA');

    if (res.isNotEmpty) {
      return res.map((venta) => VentaModel.fromJson(venta)).toList();
    } else {
      return [];
    }
  }

  Future<int> addVenta(VentaModel venta) async {
    final db = await database;
    final ventaId = await db!.insert('VENTA', venta.toJson());
    return ventaId;
  }

  Future<List<DetalleVentaModel>> getAllDetalleVenta() async {
    final db = await database;
    final res = await db!.query('DETALLE_VENTA');

    if (res.isNotEmpty) {
      return res.map((detalle) => DetalleVentaModel.fromJson(detalle)).toList();
    } else {
      return [];
    }
  }

  Future<int> addDetalleVenta(DetalleVentaModel detallesVenta) async {
    final db = await database;
    final detalleVentaId =
        await db!.insert('DETALLE_VENTA', detallesVenta.toJson());
    return detalleVentaId;
  }
//////////////////////////////////////////////// planes ////////////////////////////////////////////////

  Future<PlanModel> newPlan(PlanModel newPlan) async {
    final db = await database;
    final res = await db?.insert('PLANES_DE_SUSCRIPCION', newPlan.toJson());
    // Asigna el ID generado automáticamente al usuario y lo devuelve.
    newPlan.id = res;
    return newPlan;
  }

  Future<int?> deletePlanByID(int id) async {
    //matar por id al plan?
    final db = await database;
    final res = await db!
        .delete('PLANES_DE_SUSCRIPCION', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<List<PlanModel>> getPlans() async {
    final db = await database;
    final res = await db!.query('PLANES_DE_SUSCRIPCION');
    return res.isNotEmpty ? res.map((e) => PlanModel.fromJson(e)).toList() : [];
  }

  Future<int?> updatePlan(PlanModel updatePlan) async {
    final db = await database;
    final res = await db!.update('PLANES_DE_SUSCRIPCION', updatePlan.toJson(),
        where: 'id = ?', whereArgs: [updatePlan.id]);
    return res;
  }

//////////////////////////////////////////////// suscripciones ////////////////////////////////////////////////
  Future<SuscripcionesModel> newSuscripcion(
      SuscripcionesModel newSuscripcion) async {
    final db = await database;
    final res = await db?.insert('SUSCRIPCIONES', newSuscripcion.toJson());

    // Asigna el ID generado automáticamente a la suscripción y lo devuelve.
    newSuscripcion.id = res;
    return newSuscripcion;
  }

  Future<List<SuscripcionesModel>> getSuscripcionesAll() async {
    final db = await database;
    final res = await db!.query('SUSCRIPCIONES');
    return res.isNotEmpty
        ? res.map((e) => SuscripcionesModel.fromJson(e)).toList()
        : [];
  }

  //COMPRA SUSCRIPCIONES

  Future<CompraSuscripcion> newCompraSuscripcion(
      CompraSuscripcion newCompraSuscripcion) async {
    final db = await database;
    final res =
        await db?.insert('COMPRA_SUSCRIPCION', newCompraSuscripcion.toJson());

    // Asigna el ID generado automáticamente a la compra de suscripción y lo devuelve.
    newCompraSuscripcion.id = res;
    return newCompraSuscripcion;
  }

  Future<List<CompraSuscripcion>> getCompraSuscripcionesAll() async {
    final db = await database;
    final res = await db!.query('COMPRA_SUSCRIPCION');
    return res.isNotEmpty
        ? res.map((e) => CompraSuscripcion.fromJson(e)).toList()
        : [];
  }

  Future<List<SuscripcionesModel>> getActiveSubscription(int userId) async {
    final db = await database;
    final res = await db!.query(
      'SUSCRIPCIONES',
      where: 'id_usuario = ? AND estado = ?',
      whereArgs: [userId, "Activo"],
    );

    if (res.isNotEmpty) {
      return res.map((s) => SuscripcionesModel.fromJson(s)).toList();
    } else {
      return [];
    }
  }

  Future<void> updateSubscriptionStatus() async {
    final db = await database;
    final result = await db!
        .query('SUSCRIPCIONES', where: 'estado = ?', whereArgs: ["Activo"]);
    result.forEach((subscription) {
      DateTime endDate = DateTime.parse(subscription["fecha_fin"] as String);

      if (DateTime.now().isAfter(endDate)) {
        db.update(
          'SUSCRIPCIONES',
          {'estado': "Inactivo"},
          where: 'id = ?',
          whereArgs: [subscription["id"]],
        );
      }
    });
  }

  //////////////////////////////////////////////// kpi ////////////////////////////////////////////////

  // Obtener el producto más vendido
  Future<ProductModel> getTopSellingProduct() async {
    final db = await database;
    final result = await db!.rawQuery('''
      SELECT PRODUCTO.*, SUM(DETALLE_VENTA.cantidad) as total_sold 
      FROM PRODUCTO 
      JOIN DETALLE_VENTA ON PRODUCTO.id = DETALLE_VENTA.producto_id
      GROUP BY PRODUCTO.id
      ORDER BY total_sold DESC
      LIMIT 1
    ''');

    if (result.isNotEmpty) {
      return ProductModel.fromJson(result.first);
    } else {
      throw Exception('Producto no encontrado');
    }
  }

  // Obtener el usuario que más compró
  Future<UserModel> getTopBuyingUser() async {
    final db = await database;
    final result = await db!.rawQuery('''
      SELECT USUARIO.*, SUM(DETALLE_VENTA.cantidad) as total_bought
      FROM USUARIO 
      JOIN VENTA ON USUARIO.id = VENTA.usuario_id
      JOIN DETALLE_VENTA ON VENTA.id = DETALLE_VENTA.venta_id
      GROUP BY USUARIO.id
      ORDER BY total_bought DESC
      LIMIT 1
    ''');

    if (result.isNotEmpty) {
      return UserModel.fromJson(result.first);
    } else {
      throw Exception('No user found');
    }
  }

  // Obtener el total de ventas
  Future<double> getTotalSales() async {
    final db = await database;
    final result = await db!.rawQuery('''
        SELECT SUM(total) as total_sales 
        FROM VENTA
      ''');

    // If the result is not empty and total_sales is not null, return the value. Otherwise, return 0.0.
    return result.isNotEmpty && result.first["total_sales"] != null
        ? result.first["total_sales"] as double
        : 0.0;
  }

  Future<int> getTotalActiveSubscriptions() async {
    final db = await database;
    final result = await db!.rawQuery('''
      SELECT COUNT(*) as total_active_subscriptions 
      FROM SUSCRIPCIONES
      WHERE estado = 'Activo'
    ''');

    return result.isNotEmpty &&
            result.first["total_active_subscriptions"] != null
        ? result.first["total_active_subscriptions"] as int
        : 0;
  }

  Future<PlanModel> getMostPopularSubscriptionPlan() async {
    final db = await database;
    final result = await db!.rawQuery('''
      SELECT PLANES_DE_SUSCRIPCION.*, COUNT(SUSCRIPCIONES.id) as total_subscriptions 
      FROM PLANES_DE_SUSCRIPCION
      JOIN SUSCRIPCIONES ON PLANES_DE_SUSCRIPCION.id = SUSCRIPCIONES.id_plan
      GROUP BY PLANES_DE_SUSCRIPCION.id
      ORDER BY total_subscriptions DESC
      LIMIT 1
    ''');

    if (result.isNotEmpty) {
      return PlanModel.fromJson(result.first);
    } else {
      throw Exception('Plan no encontrado');
    }
  }

  Future<double> getTotalSubscriptionRevenue() async {
    final db = await database;
    final result = await db!.rawQuery('''
      SELECT SUM(COMPRA_SUSCRIPCION.total) as total_revenue 
      FROM COMPRA_SUSCRIPCION
    ''');

    return result.isNotEmpty && result.first["total_revenue"] != null
        ? result.first["total_revenue"] as double
        : 0.0;
  }

  // Obtener las ventas mensuales
  Future<List<SalesData>> getMonthlySales() async {
    final db = await database;
    final result = await db!.rawQuery('''
    SELECT strftime('%Y-%m', fecha) as month, SUM(total) as total_sales
    FROM VENTA
    GROUP BY month
  ''');

    if (result.isNotEmpty) {
      final salesDataList = result.map((row) {
        final month = row['month'] as String;
        final totalSales = row['total_sales'] as double;
        return SalesData(month, totalSales);
      }).toList();
      return salesDataList;
    } else {
      throw Exception('No se encontraron datos de ventas mensuales.');
    }
  }
}
