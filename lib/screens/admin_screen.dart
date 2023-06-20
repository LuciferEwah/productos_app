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
        title: const Text('KPI Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            FutureBuilder<ProductModel>(
              future: _topSellingProduct,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    title: const Text('Producto más vendido'),
                    subtitle: Text('${snapshot.data!.nombre}'),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            FutureBuilder<UserModel>(
              future: _topBuyingUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    title: const Text('Usuario que más compró'),
                    subtitle: Text(snapshot.data!.email),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
            FutureBuilder<double>(
              future: _totalSales,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListTile(
                    title: const Text('Total de ventas'),
                    subtitle: Text('${snapshot.data!}'),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
