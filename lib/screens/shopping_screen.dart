import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:provider/provider.dart';

import '../providers/product_list_provider.dart';
import '../providers/user_list_provider.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  Map<int, int> cantidad = {};
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    products = Provider.of<ProductListProvider>(context, listen: false)
        .productsForCard;
    for (var product in products) {
      cantidad[product.id!] = 1;
    }
  }

  double get subtotal {
    if (products.isEmpty) {
      return 0;
    }
    return products
        .map((p) => p.precio * cantidad[p.id]!)
        .reduce((a, b) => a + b);
  }

  double get iva => subtotal * 0.19;

  double get total => subtotal + iva;

  void removeProduct(ProductModel product) {
    setState(() {
      Provider.of<ProductListProvider>(context, listen: false)
          .removeProductFromCart(product);
      cantidad.remove(product.id); // Elimina la entrada en el mapa 'cantidad'
    });
  }

  @override
  Widget build(BuildContext context) {
    final productListProvider = Provider.of<ProductListProvider>(context);
    final userListProvider = Provider.of<UserListProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (BuildContext context, int index) {
                final product = products[index];
                return Dismissible(
                  key: Key(product.nombre),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) => removeProduct(product),
                  background: Container(
                    color: Colors.red,
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  child: Container(
                    color: Colors.grey[200],
                    child: ListTile(
                      title: Text(product.nombre),
                      subtitle: Text(
                          '\$${product.precio.toStringAsFixed(2)} x ${cantidad[product.id] ?? 1}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (cantidad[product.id] != null &&
                                  cantidad[product.id]! > 1) {
                                cantidad[product.id!] =
                                    cantidad[product.id]! - 1;
                              }
                              setState(() {});
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${cantidad[product.id] ?? 1}'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                cantidad[product.id!] =
                                    (cantidad[product.id] ?? 1) + 1;
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              color: Colors.orange[700],
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:', style: TextStyle(fontSize: 18)),
                      Text('\$${subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('IVA (19%):', style: TextStyle(fontSize: 18)),
                      Text('\$${iva.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontSize: 18)),
                      Text('\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 18)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ElevatedButton(
              onPressed: () async {
                if (products.isNotEmpty) {
                  bool hasStock = true;
                  // Verificar el stock de todos los productos en el carrito
                  for (var product in products) {
                    int productId = product.id!;
                    int selectedQuantity = cantidad[productId] ?? 1;
                    bool currentProductHasStock = await productListProvider
                        .checkStock(productId, selectedQuantity);

                    if (!currentProductHasStock) {
                      hasStock = false;
                      final snackBar = SnackBar(
                          content: Text(
                              'No hay suficiente stock para ${product.nombre}'));
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      break;
                    }
                  }

                  if (hasStock) {
                    int? usuarioId = userListProvider.idUser;
                    products = productListProvider.productsForCard;
                    // Aquí se llama a la función realizarVenta() en ProductListProvider
                    await productListProvider.realizarVenta(
                        subtotal, iva, total, usuarioId, cantidad);
                    // Llamar a clearCart() para limpiar el carrito en ProductListProvider
                    productListProvider.clearCart();
                    const snackBar = SnackBar(
                        content:
                            Text('Su compra se ha realizado exitosamente'));
                    // ignore: use_build_context_synchronously
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    products = [];
                  }
                } else {
                  const snackBar = SnackBar(content: Text('Carrito vacio'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[700],
                textStyle: const TextStyle(color: Colors.black),
              ),
              child: const Text(
                'Pagar',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
