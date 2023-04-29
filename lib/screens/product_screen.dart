import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:productos_app/widgets/product_img.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/providers/provider.dart';

import '../services/services.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productListProvider = Provider.of<ProductListProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => ProductFromProvider(productListProvider.selectedProduct),
      child: _ProductScreenBody(productListProvider: productListProvider),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    super.key,
    required this.productListProvider,
  });

  final ProductListProvider productListProvider;

  @override
  Widget build(BuildContext context) {
    final productFrom = Provider.of<ProductFromProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
          //keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
        children: [
          Stack(
            children: [
              ProductImg(
                url: productListProvider.selectedProduct.imagen,
              ),
              Positioned(
                  top: 60,
                  left: 20,
                  child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        size: 40,
                        color: Colors.white,
                      ))),
              Positioned(
                  top: 60,
                  right: 30,
                  child: IconButton(
                      onPressed: () async {
                        String path = await uploadImage();
                        productListProvider.updateSelectProductImage(path);
                      },
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        size: 40,
                        color: Colors.white,
                      )))
            ],
          ),
          const _ProductFrom()
        ],
      )),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 30),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          FloatingActionButton(
            onPressed: () {
              if (productListProvider.selectedProduct.id == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Por el momento no se puede eliminar el producto, intente en otro momento'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              } else {
                productListProvider
                    .deleteById(productListProvider.selectedProduct.id!);
                Navigator.of(context).pop();
              }
            },
            heroTag: null,
            child:
                const Icon(Icons.delete_outline), // Evita un error de animación
          ),
          FloatingActionButton(
            onPressed: () {
              productListProvider.update(productFrom.product);
            },
            heroTag: null,
            child: const Icon(Icons.save_outlined),
          ),
        ]),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}

class _ProductFrom extends StatelessWidget {
  const _ProductFrom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final productFrom = Provider.of<ProductFromProvider>(context);
    final product = productFrom.product;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          decoration: _buildBoxDecoration(),
          child: Form(
            key: productFrom.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: product.nombre,
                onChanged: (value) => product.nombre = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El nombre es obligatorio';
                  }
                },
                decoration: const InputDecoration(
                    hintText: 'nombre del producto', labelText: 'nombre'),
              ),
              const SizedBox(height: 30),
              TextFormField(
                  initialValue: '${product.precio}',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^(\d+)?\.?\d{0,2}'))
                  ],
                  onChanged: (value) {
                    if (double.tryParse(value) == null) {
                      product.precio = 0;
                    } else {
                      product.precio = double.parse(value);
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'Precio del producto', labelText: 'precio')),
              const SizedBox(height: 30),
              TextFormField(
                  initialValue: '${product.stock}',
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d+$'))
                  ],
                  onChanged: (value) {
                    if (int.tryParse(value) == null) {
                      product.stock = 0;
                    } else {
                      product.stock = int.parse(value);
                    }
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      hintText: 'stock del producto', labelText: 'stock')),
              const SizedBox(height: 10),
            ]),
          )),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(25),
              bottomLeft: Radius.circular(25)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: const Offset(0, 5),
                blurRadius: 5)
          ]);
}
