import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/product_list_provider.dart'; // Importar la clase ProductListProvider

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
    this.trailing, // Agrega el parámetro aquí
    required this.productListProvider, // Agrega la instancia de ProductListProvider
  }) : super(key: key);

  final ProductModel product;
  final Widget? trailing; // Declara el parámetro aquí
  final ProductListProvider productListProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
      child: Container(
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(
              url: product.imagen,
            ),
            _DetailsProduct(
              product: product,
              productListProvider: productListProvider,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _Price(
                price: product.precio,
              ),
            ),
            if (product.stock == 0)
              const Positioned(top: 0, left: 0, child: _NotAvailabel()),
            if (trailing != null) // Agrega la condición para mostrar el widget
              Positioned(
                bottom: 0,
                right: 0,
                child: trailing!,
              ),
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
              color: Colors.black38, blurRadius: 10, offset: Offset(0, 5)),
        ]);

class _NotAvailabel extends StatelessWidget {
  const _NotAvailabel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 120,
      decoration: const BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20), topLeft: Radius.circular(25))),
      child: const FittedBox(
        fit: BoxFit.contain,
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'No disponible',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )),
      ),
    );
  }
}

class _Price extends StatelessWidget {
  const _Price({
    required this.price,
  });

  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.orange[700],
          borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(20), topRight: Radius.circular(25))),
      height: 40,
      width: 150,
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            '\$$price',
            style: const TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
      ),
    );
  }
}

class _DetailsProduct extends StatelessWidget {
  const _DetailsProduct({
    required this.product,
    required this.productListProvider, // Agrega la instancia de ProductListProvider
  });

  final ProductModel product;
  final ProductListProvider
      productListProvider; // Declara la instancia de ProductListProvider

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.nombre,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(product.id.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)
              ],
            ),
            ElevatedButton(
              onPressed: product.stock > 0//AAAAA
                  ? () {
                      bool productAdded =
                          productListProvider.addToCart(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: productAdded
                              ? Text(
                                  'Producto agregado al carrito: ${product.nombre}')
                              : Text(
                                  'El producto ya está en el carrito: ${product.nombre}'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.orange[700],
              ),
              child: Text(product.stock > 0 ? 'Comprar' : 'No disponible'),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)),
      color: Colors.orange[700]);
}

class _BackgroundImage extends StatelessWidget {
  const _BackgroundImage({
    this.url,
  });

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: url == null
            ? const Image(
                image: AssetImage('assets/no-image.png'), fit: BoxFit.cover)
            : FadeInImage(
                placeholder: const AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(url!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
