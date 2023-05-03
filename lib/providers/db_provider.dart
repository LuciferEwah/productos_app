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
    final path = join(documentsDirectory.path, 'ProductosDB.db');
    print(path);
    return await openDatabase(path, version: 3,
        onCreate: (Database db, int version) async {
      // Crea la tabla 'usuario'
      await db.execute(
          'CREATE TABLE USUARIO (id INTEGER PRIMARY KEY, email TEXT, contrasena TEXT)');
      // Crea la tabla 'producto'
      await db.execute(
          'CREATE TABLE PRODUCTO (id INTEGER PRIMARY KEY, nombre TEXT, categoria TEXT, precio REAL, stock INTEGER, imagen TEXT)');
      // Crea la tabla 'venta'
      await db.execute(
          'CREATE TABLE VENTA (id INTEGER PRIMARY KEY, fecha TEXT, total REAL, usuario_id INTEGER, FOREIGN KEY(usuario_id) REFERENCES USUARIO(id))');
      // Crea la tabla 'detalle_venta'
      await db.execute(
          'CREATE TABLE DETALLE_VENTA (id INTEGER PRIMARY KEY, venta_id INTEGER, producto_id INTEGER, cantidad INTEGER, subtotal REAL, FOREIGN KEY(venta_id) REFERENCES VENTA(id), FOREIGN KEY(producto_id) REFERENCES PRODUCTO(id))');
    });
  }
//////////////////////////////////////////////// producto ////////////////////////////////////////////////
  Future<int?> newProduct(ProductModel newProduct) async {
    final db = await database;
    final res = await db?.insert('PRODUCTO', newProduct.toJson());
    //Es el ID del ultimo resgistro insertado
    return res;
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
  );
  return await db.updateProduct(updatedProduct);
}

//////////////////////////////////////////////// usuario ////////////////////////////////////////////////
  Future<int?> newUser(UserModel newUser) async {
    final db = await database;
    final res = await db?.insert('USUARIO', newUser.toJson());
    //Es el ID del ultimo resgistro insertado
    return res;
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
    return res.isNotEmpty
        ? res.map((e) => UserModel.fromJson(e)).toList()
        : [];
  }

  Future<int?> deleteUserById(int id) async {
    final db = await database;
    final res = await db!.delete('USUARIO', where: 'id = ?', whereArgs: [id]);
    return res;
  }
  //////////////////////////////////////////////// venta ////////////////////////////////////////////////
  Future<void> addVentaAndDetalleVenta(VentaModel venta, List<DetalleVentaModel> detallesVenta) async {
  final db = await DBProvider.db.database;

  // Insertar venta
  final ventaId = await db!.insert('VENTA', venta.toJson());

  // Insertar detallesVenta
  for (final detalleVenta in detallesVenta) {
    final Map<String, dynamic> detalleVentaData = {
      'producto_id': detalleVenta.productoId,
      'cantidad': detalleVenta.cantidad,
      'subtotal': detalleVenta.subtotal,
      'venta_id': ventaId,
    };
    await db.insert('DETALLE_VENTA', detalleVentaData);
  }
}

}