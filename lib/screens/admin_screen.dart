import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import '../providers/db_provider.dart';

class KpiScreen extends StatefulWidget {
  KpiScreen({Key? key}) : super(key: key);

  @override
  _KpiScreenState createState() => _KpiScreenState();
}

class _KpiScreenState extends State<KpiScreen> {
  late Future<ProductModel> _topSellingProduct;
  late Future<UserModel> _topBuyingUser;
  late Future<double> _totalSales;

  @override
  void initState() {
    super.initState();
    _topSellingProduct = DBProvider.db.getTopSellingProduct();
    _topBuyingUser = DBProvider.db.getTopBuyingUser();
    _totalSales = DBProvider.db.getTotalSales();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Indicadores Clave'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: FutureBuilder<ProductModel>(
                future: _topSellingProduct,
                builder: (context, snapshot) {
                  if (!mounted)
                    return Container(); // Verificar si el widget está montado
                  if (snapshot.hasData) {
                    return ListTile(
                      title: Text(
                        'Producto más vendido',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data!.nombre,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
            Container(
              color: Colors.white,
              child: FutureBuilder<UserModel>(
                future: _topBuyingUser,
                builder: (context, snapshot) {
                  if (!mounted)
                    return Container(); // Verificar si el widget está montado
                  if (snapshot.hasData) {
                    return ListTile(
                      title: Text(
                        'Usuario que más compró',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        snapshot.data!.email,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
            Container(
              color: Colors.white,
              child: FutureBuilder<double>(
                future: _totalSales,
                builder: (context, snapshot) {
                  if (!mounted)
                    return Container(); // Verificar si el widget está montado
                  if (snapshot.hasData) {
                    return ListTile(
                      title: Text(
                        'Ventas totales',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        '${snapshot.data!}',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
