import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:provider/provider.dart';

import '../providers/product_list_provider.dart';

class ShoppingScreen extends StatefulWidget {
  const ShoppingScreen({Key? key}) : super(key: key);

  @override
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
    products.asMap().forEach((index, product) {
      cantidad[index] = 1;
    });
  }

  double get subtotal {
    if (products.isEmpty) {
      return 0;
    }
    return products
        .map((p) => p.precio)
        .toList()
        .asMap()
        .entries
        .map((e) => e.value * cantidad[e.key]!)
        .reduce((a, b) => a + b);
  }

  double get iva => subtotal * 0.19;

  double get total => subtotal + iva;

  void removeProduct(ProductModel product) {
    final int index = products.indexOf(product);
    if (index >= 0) {
      setState(() {
        products.removeAt(index);
        cantidad.remove(index);
        Provider.of<ProductListProvider>(context, listen: false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ProductModel> products =
        Provider.of<ProductListProvider>(context).productsForCard;

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
                          '\$${product.precio.toStringAsFixed(2)} x ${cantidad[index] ?? 1}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (cantidad[index] != null &&
                                  cantidad[index]! > 1) {
                                cantidad[index] = cantidad[index]! - 1;
                              }
                              setState(() {});
                            },
                            icon: const Icon(Icons.remove),
                          ),
                          Text('${cantidad[index] ?? 1}'),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                cantidad[index] = (cantidad[index] ?? 1) + 1;
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
              onPressed: () {
                // Acción del botón de pago

                print('Detalles de la compra:');

                products.asMap().forEach((index, product) {
                  print(
                      'ID: ${product.id}, NOMBRE: ${product.nombre}, PRECIO: ${product.precio.toStringAsFixed(2)}, Cantidad: ${cantidad[index]}');
                });
                print('Fecha: ${DateTime.now()}');
                print('Subtotal: ${subtotal.toStringAsFixed(2)}');
                print('IVA: ${iva.toStringAsFixed(2)}');
                print('Total: ${total.toStringAsFixed(2)}');
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
