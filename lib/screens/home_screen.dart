import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';
import 'package:productos_app/screens/screens.dart';

import 'package:productos_app/widgets/widgets.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
import '../providers/product_list_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productListProvider = Provider.of<ProductListProvider>(context);

    if (productListProvider.isLoading) return const LoadingScreen();

    //TODO: COMO ACCEDER A LA INFORMACION

    // Obtener la lista de productos
    //print(productListProvider);
    //final products = productListProvider.products;
    //print(products[0].categoria);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: productListProvider.products.length,
        itemBuilder: (context, i) => GestureDetector(
          child: ProductCard(
            product: productListProvider.products[i],
          ),
          onTap: () => Navigator.pushNamed(context, 'producto'),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_a_photo),
        onPressed: () {},
      ),
    );
  }
}
