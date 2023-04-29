import 'package:flutter/material.dart';
import 'package:productos_app/screens/screens.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/product_list_provider.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);
//TODO: eliminar
  final List<String> productListShopping = [
    'Control Xbox!',
    'Control Xbox!',
    'Product C',
    'Product D',
  ];

  @override
  Widget build(BuildContext context) {
    final productListProvider = Provider.of<ProductListProvider>(context);

    if (productListProvider.isLoading) return const LoadingScreen();

    //TODO: COMO ACCEDER A LA INFORMACION

    // Obtener la lista de productos
    //print(productListProvider);
    //final products = productListProvider.products;
    //print(products[2].id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
        centerTitle: true,
        actions: [
          ButtonShoping(
              productList: productListShopping,
              productListProvider: productListProvider),
        ],
      ),
      body: ListView.builder(
        itemCount: productListProvider.products.length,
        itemBuilder: (context, i) => GestureDetector(
            child: ProductCard(
              product: productListProvider.products[i],
            ),
            onTap: () {
              productListProvider.selectedProduct =
                  productListProvider.products[i].copy();
              Navigator.pushNamed(context, 'producto');
            }),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          productListProvider.newProduct(nombre: '', precio: 0.0, stock: 0);
        },
      ),
    );
  }
}

class ButtonShoping extends StatelessWidget {
  const ButtonShoping({
    super.key,
    required this.productList,
    required this.productListProvider,
  });

  final List<String> productList;
  final ProductListProvider productListProvider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.pushNamed(context, 'carrito');
          },
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              productList
                  .where((product) => productListProvider.products
                      .any((p) => p.nombre == product))
                  .length
                  .toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
