import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';

import 'package:productos_app/widgets/widgets.dart';
// ignore: unused_import
import 'package:provider/provider.dart';
import '../providers/product_list_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //final productsService = Provider.of<ProductsService>(context);
    // Obtener la instancia de ProductListProvider
    final productListProvider = Provider.of<ProductListProvider>(context);
    // Obtener la lista de productos
    final products = productListProvider.products;

    // Obtener la primera categoría
    final firstCategory = products[0].categoria;

    // Imprimir el nombre de la primera categoría
    print(firstCategory);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, i) => GestureDetector(
          child: const ProductCard(),
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
